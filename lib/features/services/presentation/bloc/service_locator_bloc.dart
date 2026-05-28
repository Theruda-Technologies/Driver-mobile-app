library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/usecases/enrich_garage_center_usecase.dart';
import '../../application/usecases/get_nearby_garages_usecase.dart';
import '../../domain/entities/service_center.dart';
import '../../domain/errors/service_locator_failure.dart';
import 'service_locator_event.dart';
import 'service_locator_state.dart';

class ServiceLocatorBloc
    extends Bloc<ServiceLocatorEvent, ServiceLocatorState> {
  /// UI maps this to [AppLocalizations.svcUnableLoadGarages].
  static const String kFailureUnableLoadNearby = '__failure_unable_load_nearby__';

  ServiceLocatorBloc(
    this._getNearbyGarages,
    this._enrichGarageCenter,
  ) : super(ServiceLocatorState.initial()) {
    on<InitializeServiceLocator>(_onInitialize);
    on<LoadNearbyGarages>(_onLoadNearbyGarages);
    on<SelectServiceCenter>(_onSelectCenter);
    on<ClearSelectedCenter>(_onClearSelectedCenter);
    on<UpdateVisibleCenters>(_onUpdateVisibleCenters);
    on<RefreshNearbyGaragesRequested>(_onRefreshNearbyGaragesRequested);
    on<EnrichGarageCenterRequested>(_onEnrichGarageCenter);
  }

  final GetNearbyGaragesUseCase _getNearbyGarages;
  final EnrichGarageCenterUseCase _enrichGarageCenter;

  Future<void> _onInitialize(
    InitializeServiceLocator event,
    Emitter<ServiceLocatorState> emit,
  ) async {
    await _loadNearby(emit, null, null);
  }

  Future<void> _onLoadNearbyGarages(
    LoadNearbyGarages event,
    Emitter<ServiceLocatorState> emit,
  ) async {
    await _loadNearby(emit, event.latitude, event.longitude);
  }

  Future<void> _loadNearby(
    Emitter<ServiceLocatorState> emit,
    double? lat,
    double? lng,
  ) async {
    emit(state.copyWith(isLoading: true, failureMessage: null));
    try {
      final centers = await _getNearbyGarages(latitude: lat, longitude: lng);
      emit(
        state.copyWith(
          centers: centers,
          visibleCenterIds: centers.map((c) => c.id).toList(),
          selectedCenterId: centers.isNotEmpty ? centers.first.id : null,
          isLoading: false,
          lastLatitude: lat,
          lastLongitude: lng,
          failureMessage: null,
        ),
      );

      // Top up missing hours/ratings from profile without replacing nearby identity.
      final needsRefresh = centers.any(_cardNeedsProfileTopUp);
      if (needsRefresh && !isClosed) {
        final refreshed = await Future.wait(
          centers.map((center) async {
            if (!_cardNeedsProfileTopUp(center)) return center;
            try {
              return await _enrichGarageCenter(center);
            } catch (_) {
              return center;
            }
          }),
        );
        if (!isClosed) {
          emit(state.copyWith(centers: refreshed));
        }
      }
    } on ServiceLocatorException catch (e) {
      emit(state.copyWith(isLoading: false, failureMessage: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          failureMessage: kFailureUnableLoadNearby,
        ),
      );
    }
  }

  void _onSelectCenter(
    SelectServiceCenter event,
    Emitter<ServiceLocatorState> emit,
  ) {
    emit(state.copyWith(selectedCenterId: event.centerId));
    add(EnrichGarageCenterRequested(event.centerId));
  }

  Future<void> _onEnrichGarageCenter(
    EnrichGarageCenterRequested event,
    Emitter<ServiceLocatorState> emit,
  ) async {
    final index = state.centers.indexWhere((c) => c.id == event.centerId);
    if (index < 0) return;

    final current = state.centers[index];
    try {
      final enriched = await _enrichGarageCenter(current);
      final centers = List<ServiceCenter>.from(state.centers);
      centers[index] = enriched;
      emit(state.copyWith(centers: centers));
    } catch (_) {
      // Keep existing card data if profile refresh fails.
    }
  }

  void _onClearSelectedCenter(
    ClearSelectedCenter event,
    Emitter<ServiceLocatorState> emit,
  ) {
    emit(state.copyWith(clearSelectedCenter: true));
  }

  void _onUpdateVisibleCenters(
    UpdateVisibleCenters event,
    Emitter<ServiceLocatorState> emit,
  ) {
    emit(state.copyWith(visibleCenterIds: event.visibleCenterIds));
  }

  bool _cardNeedsProfileTopUp(ServiceCenter center) =>
      center.availabilitySlots.isEmpty || !center.onsiteServiceEnabled;

  Future<void> _onRefreshNearbyGaragesRequested(
    RefreshNearbyGaragesRequested event,
    Emitter<ServiceLocatorState> emit,
  ) async {
    await _loadNearby(emit, state.lastLatitude, state.lastLongitude);
  }
}
