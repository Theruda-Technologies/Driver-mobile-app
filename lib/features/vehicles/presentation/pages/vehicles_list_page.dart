library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/border_radius.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/driver_shell_bottom_nav_bar.dart';
import '../../../../core/widgets/nav_app_bar.dart';
import '../../../../injection/service_locator.dart';
import '../../../maintenance/domain/entities/maintenance_upcoming.dart';
import '../../../maintenance/presentation/bloc/maintenance_bloc.dart';
import '../../../maintenance/presentation/bloc/maintenance_event.dart';
import '../../../maintenance/presentation/bloc/maintenance_state.dart';
import '../../../maintenance/presentation/pages/schedule_maintenance_page.dart';
import '../../../maintenance/presentation/models/maintenance_timeline_entry.dart';
import '../../../maintenance/presentation/widgets/maintenance_timeline_list_item.dart';
import '../../../maintenance/presentation/widgets/maintenance_upcoming_list_item.dart';
import '../../domain/entities/vehicle.dart';
import '../bloc/vehicles_bloc.dart';
import '../bloc/vehicles_event.dart';
import '../bloc/vehicles_state.dart';
import 'vehicle_detail_page.dart';

class VehiclesListPage extends StatelessWidget {
  const VehiclesListPage({super.key, this.initialTab, this.focusUpcomingId});

  /// 0 = My Vehicles, 1 = Upcoming, 2 = History
  final int? initialTab;

  /// When set (e.g. from a notification), Upcoming opens and scrolls to this reminder.
  final String? focusUpcomingId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VehiclesBloc>(
          create: (_) => getIt<VehiclesBloc>()..add(const VehiclesLoadRequested()),
        ),
        BlocProvider<MaintenanceBloc>(
          create: (_) => getIt<MaintenanceBloc>()..add(const MaintenanceLoadRequested()),
        ),
      ],
      child: _VehiclesHubView(initialTab: initialTab, focusUpcomingId: focusUpcomingId),
    );
  }
}

class _VehiclesHubView extends StatefulWidget {
  const _VehiclesHubView({this.initialTab, this.focusUpcomingId});

  final int? initialTab;
  final String? focusUpcomingId;

  @override
  State<_VehiclesHubView> createState() => _VehiclesHubViewState();
}

class _VehiclesHubViewState extends State<_VehiclesHubView> {
  late int _tab; // 0 vehicles, 1 upcoming, 2 history

  @override
  void initState() {
    super.initState();
    final t = widget.initialTab;
    if (t != null && t >= 0 && t <= 2) {
      _tab = t;
    } else if (widget.focusUpcomingId != null && widget.focusUpcomingId!.trim().isNotEmpty) {
      _tab = 1;
    } else {
      _tab = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(currentRoute: '/vehicles'),
      appBar: NavAppBar.mainShell(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.lg,
            Spacing.lg,
            Spacing.lg + Dimensions.bottomNavHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tab == 1
                              ? l10n.vehListTitleUpcoming
                              : _tab == 2
                                  ? l10n.vehListTitleHistory
                                  : l10n.vehListTitleMyVehicles,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _tab == 1
                              ? l10n.vehListSubtitleUpcoming
                              : _tab == 2
                                  ? l10n.vehListSubtitleHistory
                                  : l10n.vehListSubtitleMyVehicles,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
              _SegmentTabs(
                value: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: Spacing.lg),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _tab == 1
                      ? _UpcomingMaintenanceTab(
                          key: const ValueKey('upcoming'),
                          focusUpcomingId: widget.focusUpcomingId,
                        )
                      : _tab == 2
                          ? const _MaintenanceHistoryTab(key: ValueKey('history'))
                          : const _VehiclesTab(key: ValueKey('vehicles')),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const DriverShellBottomNavBar(current: DriverShellTab.vehicles),
    );
  }
}

class _SegmentTabs extends StatelessWidget {
  const _SegmentTabs({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabPill(
              label: l10n.vehSegmentMyVehicles,
              selected: value == 0,
              onTap: () => onChanged(0),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _TabPill(
              label: l10n.vehSegmentUpcoming,
              selected: value == 1,
              onTap: () => onChanged(1),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _TabPill(
              label: l10n.vehSegmentHistory,
              selected: value == 2,
              onTap: () => onChanged(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _VehiclesTab extends StatelessWidget {
  const _VehiclesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehiclesBloc, VehiclesState>(
      builder: (context, state) {
        if (state is VehiclesLoading && state is! VehiclesLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VehiclesFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.danger),
                  const SizedBox(height: Spacing.md),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: Spacing.lg),
                  TextButton(
                    onPressed: () => context.read<VehiclesBloc>().add(const VehiclesLoadRequested()),
                    child: Text(
                      AppLocalizations.of(context)!.commonRetry,
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final vehicles = state is VehiclesLoaded ? state.vehicles : <Vehicle>[];
        return ListView(
          children: [
            for (final v in vehicles)
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.sm),
                child: _VehicleListCard(
                  vehicle: v,
                  onTap: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (context) => VehicleDetailPage(vehicleId: v.id),
                      ),
                    );
                    if (context.mounted && result == true) {
                      context.read<VehiclesBloc>().add(const VehiclesLoadRequested());
                    }
                  },
                ),
              ),
            _AddNewVehicleCard(
              onTap: () async {
                await Navigator.of(context).pushNamed('/vehicles/add');
                if (context.mounted) {
                  context.read<VehiclesBloc>().add(const VehiclesLoadRequested());
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _AddNewVehicleCard extends StatelessWidget {
  const _AddNewVehicleCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: Spacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.textPrimary),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              l10n.vehFabAddNewVehicle,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.vehFabRegisterAnother,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingMaintenanceTab extends StatefulWidget {
  const _UpcomingMaintenanceTab({super.key, this.focusUpcomingId});

  final String? focusUpcomingId;

  @override
  State<_UpcomingMaintenanceTab> createState() => _UpcomingMaintenanceTabState();
}

class _UpcomingMaintenanceTabState extends State<_UpcomingMaintenanceTab> {
  final GlobalKey _focusKey = GlobalKey();
  bool _didScrollToFocus = false;
  bool _scrollRequestPosted = false;
  int _scrollAttempts = 0;

  void _requestScrollToFocus(List<MaintenanceUpcoming> items, String? focusId) {
    if (focusId == null || focusId.isEmpty || _didScrollToFocus || _scrollRequestPosted) return;
    if (!items.any((u) => u.id == focusId)) return;
    _scrollRequestPosted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _runFocusScroll());
  }

  void _runFocusScroll() {
    if (!mounted || _didScrollToFocus) return;
    if (_scrollAttempts++ > 18) {
      _didScrollToFocus = true;
      return;
    }
    final ctx = _focusKey.currentContext;
    if (ctx != null) {
      _didScrollToFocus = true;
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.12,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _runFocusScroll());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceBloc, MaintenanceState>(
      builder: (context, state) {
        final fid = widget.focusUpcomingId?.trim();
        final items = state.upcoming.where((u) {
          if (fid != null && fid.isNotEmpty && u.id == fid) return true;
          return u.isActiveReminder;
        }).toList();
        if (state.loading && items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        _requestScrollToFocus(items, fid);
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
                itemBuilder: (context, i) {
                  final m = items[i];
                  final isFocus = fid != null && fid.isNotEmpty && m.id == fid;
                  Widget tile = MaintenanceUpcomingListItem(
                    item: m,
                    onDelete: () {
                      if (!context.mounted) return;
                      context.read<MaintenanceBloc>().add(MaintenanceUpcomingDeleteRequested(m.id));
                    },
                    onToggleReminder: () {
                      context.read<MaintenanceBloc>().add(MaintenanceToggleReminderRequested(m.id));
                    },
                    onMarkDone: m.canMarkDoneFromUi
                        ? () => context.read<MaintenanceBloc>().add(MaintenanceMarkDoneRequested(m.id))
                        : null,
                  );
                  if (isFocus) {
                    tile = Container(
                      key: _focusKey,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.secondary, width: 2),
                      ),
                      child: tile,
                    );
                  }
                  return tile;
                },
              ),
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final vehiclesBloc = _maybeVehiclesBloc(context);
                  final maintenanceBloc = context.read<MaintenanceBloc>();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          if (vehiclesBloc != null) BlocProvider.value(value: vehiclesBloc),
                          BlocProvider.value(value: maintenanceBloc),
                        ],
                        child: const ScheduleMaintenancePage(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(AppLocalizations.of(context)!.vehScheduleMaintenance),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

VehiclesBloc? _maybeVehiclesBloc(BuildContext context) {
  try {
    return BlocProvider.of<VehiclesBloc>(context);
  } catch (_) {
    return null;
  }
}

class _MaintenanceHistoryTab extends StatelessWidget {
  const _MaintenanceHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceBloc, MaintenanceState>(
      builder: (context, mState) {
        final timeline = buildMaintenanceTimeline(mState);
        if (mState.loading && timeline.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return BlocBuilder<VehiclesBloc, VehiclesState>(
          builder: (context, vState) {
            final vehicles = vState is VehiclesLoaded ? vState.vehicles : const <Vehicle>[];
            return timeline.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                      child: Text(
                        AppLocalizations.of(context)!.vehHistoryEmpty,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: timeline.length,
                    separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
                    itemBuilder: (context, i) {
                      final entry = timeline[i];
                      return MaintenanceTimelineListItem(
                        entry: entry,
                        vehicles: vehicles,
                      );
                    },
                  );
          },
        );
      },
    );
  }
}

class _VehicleListCard extends StatelessWidget {
  const _VehicleListCard({required this.vehicle, required this.onTap});

  final Vehicle vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isActive = vehicle.status != VehicleStatus.pending;
    final statusColor = isActive ? AppColors.success : AppColors.pending;
    final statusText = isActive ? l10n.vehCardStatusGood : l10n.vehCardStatusAttention;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.directions_car_outlined, color: Colors.white, size: 28),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.displayName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    vehicle.plateNumber,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                statusText,
                style: AppTextStyles.labelSmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

