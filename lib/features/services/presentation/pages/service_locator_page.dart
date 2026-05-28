import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/border_radius.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/network/api_error_messages.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/driver_shell_bottom_nav_bar.dart';
import '../../../../core/widgets/nav_app_bar.dart';
import '../../../../core/widgets/simple_back_app_bar.dart';
import '../../../../injection/service_locator.dart';
import '../../../appointments/domain/entities/appointment.dart';
import '../../../appointments/presentation/bloc/appointments_bloc.dart';
import '../../../appointments/presentation/bloc/appointments_event.dart';
import '../../../appointments/presentation/bloc/appointments_state.dart';
import '../../domain/entities/service_center.dart';
import '../bloc/service_locator_bloc.dart';
import '../bloc/service_locator_event.dart';
import '../bloc/service_locator_state.dart';
import 'book_service_wizard_page.dart';
import '../widgets/service_tag_chip.dart';
import '../widgets/garage_center_card_footer.dart';
import '../widgets/service_text_formatter.dart';

enum _SvcLocIssue { servicesDisabled, permissionForever, permissionDenied, fetchFailed }

String _localizedServiceLocatorFailure(BuildContext context, String raw) {
  if (raw == ServiceLocatorBloc.kFailureUnableLoadNearby) {
    return AppLocalizations.of(context)!.svcUnableLoadGarages;
  }
  return raw;
}

class ServiceLocatorPage extends StatelessWidget {
  const ServiceLocatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ServiceLocatorBloc>()),
        BlocProvider(
          create: (_) =>
              getIt<AppointmentsBloc>()..add(const AppointmentsLoadRequested()),
        ),
      ],
      child: const _ServiceLocatorView(),
    );
  }
}

class _ServiceLocatorView extends StatefulWidget {
  const _ServiceLocatorView();

  @override
  State<_ServiceLocatorView> createState() => _ServiceLocatorViewState();
}

class _ServiceLocatorViewState extends State<_ServiceLocatorView> {
  static const double _fallbackLat = 0.0;
  static const double _fallbackLng = 0.0;

  @override
  void initState() {
    super.initState();
    _loadNearbyWithLocation();
  }

  Future<void> _loadNearbyWithLocation() async {
    double lat = _fallbackLat;
    double lng = _fallbackLng;
    _SvcLocIssue? locIssue;
    var suggestOpenLocationSettings = false;
    var suggestOpenAppSettings = false;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locIssue = _SvcLocIssue.servicesDisabled;
        suggestOpenLocationSettings = true;
      } else {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.deniedForever) {
          locIssue = _SvcLocIssue.permissionForever;
          suggestOpenAppSettings = true;
        } else if (permission == LocationPermission.denied) {
          locIssue = _SvcLocIssue.permissionDenied;
          suggestOpenAppSettings = true;
        }
      }

      if (locIssue == null) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        lat = pos.latitude;
        lng = pos.longitude;
      } else {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          lat = lastKnown.latitude;
          lng = lastKnown.longitude;
        }
      }
    } catch (_) {
      locIssue ??= _SvcLocIssue.fetchFailed;
    }

    if (locIssue != null && mounted) {
      final l10n = AppLocalizations.of(context)!;
      final msg = switch (locIssue) {
        _SvcLocIssue.servicesDisabled => l10n.svcLocServicesDisabled,
        _SvcLocIssue.permissionForever => l10n.svcLocPermissionDeniedForever,
        _SvcLocIssue.permissionDenied => l10n.svcLocPermissionDenied,
        _SvcLocIssue.fetchFailed => l10n.svcLocFetchFailed,
      };
      _showLocationIssue(
        msg,
        suggestOpenLocationSettings: suggestOpenLocationSettings,
        suggestOpenAppSettings: suggestOpenAppSettings,
      );
    }

    if (!mounted) return;
    context.read<ServiceLocatorBloc>().add(
      LoadNearbyGarages(latitude: lat, longitude: lng),
    );
  }

  void _showLocationIssue(
    String message, {
    bool suggestOpenLocationSettings = false,
    bool suggestOpenAppSettings = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 6),
        action: (suggestOpenLocationSettings || suggestOpenAppSettings)
            ? SnackBarAction(
                label: l10n.settingsTitle,
                textColor: AppColors.textPrimary,
                onPressed: () async {
                  if (suggestOpenLocationSettings) {
                    await Geolocator.openLocationSettings();
                    return;
                  }
                  if (suggestOpenAppSettings) {
                    await Geolocator.openAppSettings();
                  }
                },
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(currentRoute: '/services'),
      appBar: NavAppBar.mainShell(context),
      body: SafeArea(
        child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
          listenWhen: (prev, curr) =>
              curr is AppointmentActionSuccess || curr is AppointmentsFailure,
          listener: (context, state) {
            if (state is AppointmentActionSuccess) {
              final l10n = AppLocalizations.of(context)!;
              context.read<AppointmentsBloc>().add(
                const AppointmentsLoadRequested(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.svcApptUpdated),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state is AppointmentsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.danger,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, _) =>
              BlocBuilder<ServiceLocatorBloc, ServiceLocatorState>(
                builder: (context, state) {
                  if (state.isLoading && state.centers.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.failureMessage != null && state.centers.isEmpty) {
                    return _ServiceErrorView(
                      message: _localizedServiceLocatorFailure(context, state.failureMessage!),
                      onRetry: _loadNearbyWithLocation,
                    );
                  }

                  final l10n = AppLocalizations.of(context)!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.lg,
                      vertical: Spacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.svcServiceCentersTitle,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          l10n.svcServiceCentersSubtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        _MapPreviewCard(
                          onTap: () {
                            Navigator.of(context).pushNamed('/services/map');
                          },
                        ),
                        const SizedBox(height: Spacing.lg),
                        _UpcomingAppointmentsSection(centers: state.centers),
                        const SizedBox(height: Spacing.lg),
                        _NearbyCentersSection(centers: state.centers),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
      bottomNavigationBar: const DriverShellBottomNavBar(current: DriverShellTab.service),
    );
  }
}

class _ServiceErrorView extends StatelessWidget {
  const _ServiceErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.danger),
            const SizedBox(height: Spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
              ),
              child: Text(l10n.svcRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingAppointmentsSection extends StatelessWidget {
  const _UpcomingAppointmentsSection({required this.centers});

  final List<ServiceCenter> centers;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsBloc, AppointmentsState>(
      builder: (context, state) {
        if (state is AppointmentsLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: Spacing.md),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        List<Appointment> appointments;
        if (state is AppointmentsLoaded) {
          appointments = state.appointments;
        } else if (state is AppointmentActionSuccess) {
          appointments = [state.appointment];
        } else {
          appointments = <Appointment>[];
        }
        final upcoming = appointments
            .where(
              (a) =>
                  a.status != AppointmentStatus.cancelled &&
                  a.status != AppointmentStatus.rejected &&
                  a.status != AppointmentStatus.completed,
            )
            .toList();

        final top3 = upcoming.take(3).toList();
        final hasMore = upcoming.length > 3;
        final l10n = AppLocalizations.of(context)!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.svcUpcomingAppointments,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final appointmentsBloc = context.read<AppointmentsBloc>();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => BlocProvider.value(
                          value: appointmentsBloc,
                          child: AllUpcomingAppointmentsPage(centers: centers),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    l10n.commonViewAll,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: hasMore
                          ? AppColors.textSecondary
                          : AppColors.textSecondary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            if (upcoming.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    l10n.svcNoUpcomingAppointments,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ...top3.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: _AppointmentCardFromEntity(
                    appointment: a,
                    centers: centers,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class AllUpcomingAppointmentsPage extends StatelessWidget {
  const AllUpcomingAppointmentsPage({super.key, required this.centers});

  final List<ServiceCenter> centers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) =>
          getIt<AppointmentsBloc>()..add(const AppointmentsLoadRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: SimpleBackTitleAppBar(
          titleText: l10n.svcApptsPageTitle,
          backgroundColor: AppColors.surface,
          leadingIcon: Icons.arrow_back_ios_new,
          fontWeight: FontWeight.w600,
        ),
        body: SafeArea(
          child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
            builder: (context, state) {
              List<Appointment> appointments;
              if (state is AppointmentsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AppointmentsLoaded) {
                appointments = state.appointments;
              } else if (state is AppointmentActionSuccess) {
                appointments = [state.appointment];
              } else {
                appointments = <Appointment>[];
              }

              final allAppointments = appointments;

              if (allAppointments.isEmpty) {
                return Center(
                  child: Text(
                    l10n.svcNoAppointmentsYet,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.lg,
                ),
                itemCount: allAppointments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.sm),
                    child: _AppointmentCardFromEntity(
                      appointment: allAppointments[index],
                      centers: centers,
                    ),
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: const DriverShellBottomNavBar(current: DriverShellTab.service),
      ),
    );
  }
}

class _AppointmentCardFromEntity extends StatelessWidget {
  const _AppointmentCardFromEntity({
    required this.appointment,
    required this.centers,
  });

  final Appointment appointment;
  final List<ServiceCenter> centers;

  String get _garageName {
    try {
      return centers.firstWhere((c) => c.id == appointment.garageId).name;
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusLabel = _statusLabel(l10n, appointment.status);
    final statusColor = _statusColor(appointment.status);
    final dateStr = _formatDate(appointment.scheduledAt);
    final timeStr = _formatTime(appointment.scheduledAt);

    final resolvedGarage = _garageName.trim().isNotEmpty ? _garageName : l10n.commonGarage;
    final garageName = appointment.garageName ?? resolvedGarage;
    final carName = appointment.vehicleName ?? l10n.commonEmDash;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  appointment.serviceSummary.isNotEmpty
                      ? formatServiceLine(appointment.serviceSummary)
                      : l10n.apptServiceDefault,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(
                    BorderRadiusValues.circular,
                  ),
                ),
                child: Text(
                  statusLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _statusTextColor(appointment.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.apptGarageLine(garageName),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.apptCarLine(carName),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                dateStr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: Spacing.xs),
              Text(
                timeStr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          if (appointment.status == AppointmentStatus.completed)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _onRateGarage(context),
                icon: const Icon(Icons.star_rounded),
                label: Text(AppLocalizations.of(context)!.svcRateGarage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onReschedule(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                    ),
                    child: Text(AppLocalizations.of(context)!.svcReschedule),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _onCancel(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                    ),
                    child: Text(AppLocalizations.of(context)!.svcCancel),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _onRateGarage(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final reviewCtrl = TextEditingController();
    int stars = 0;
    final submit = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            final dL10n = AppLocalizations.of(ctx)!;
            return AlertDialog(
              title: Text(dL10n.svcRateGarage),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dL10n.svcRateExperienceTitle),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    stars == 0
                        ? dL10n.svcRateTapStar
                        : dL10n.svcRateStarsSelected(stars),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: stars == 0
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (i) {
                      final on = i < stars;
                      return IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => setState(() => stars = i + 1),
                        icon: Icon(
                          on ? Icons.star_rounded : Icons.star_border_rounded,
                          color: on
                              ? AppColors.warning
                              : AppColors.textSecondary,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: Spacing.sm),
                  TextField(
                    controller: reviewCtrl,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: dL10n.svcRateFeedbackHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(dL10n.commonCancel),
                ),
                FilledButton(
                  onPressed: stars == 0
                      ? null
                      : () => Navigator.of(ctx).pop(true),
                  child: Text(dL10n.commonSubmit),
                ),
              ],
            );
          },
        );
      },
    );
    if (submit != true) return;
    try {
      await getIt<ApiClient>().dio.post(
        ApiEndpoints.driverAppointmentReview(appointment.id),
        data: {
          'rating': stars,
          if (reviewCtrl.text.trim().isNotEmpty)
            'comment': reviewCtrl.text.trim(),
        },
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.svcRatingThanks),
          backgroundColor: AppColors.success,
        ),
      );
      if (!context.mounted) return;
      try {
        context.read<ServiceLocatorBloc>().add(
          const RefreshNearbyGaragesRequested(),
        );
      } catch (_) {}
    } on DioException catch (e) {
      final msg = ApiErrorMessages.from(
        e,
        fallback: l10n.svcUnableSubmitRating,
      );
      messenger.showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: AppColors.danger),
      );
    }
  }

  Future<void> _onReschedule(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: appointment.scheduledAt.isAfter(DateTime.now())
          ? appointment.scheduledAt
          : DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(appointment.scheduledAt),
    );
    if (time == null || !context.mounted) return;
    final scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    context.read<AppointmentsBloc>().add(
      AppointmentRescheduleRequested(
        id: appointment.id,
        scheduledAt: scheduledAt,
      ),
    );
  }

  Future<void> _onCancel(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dL10n.svcCancelApptTitle),
          content: Text(dL10n.svcCancelApptBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(dL10n.commonNo),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(dL10n.commonYes, style: TextStyle(color: AppColors.danger)),
            ),
          ],
        );
      },
    );
    if (confirm == true && context.mounted) {
      context.read<AppointmentsBloc>().add(
        AppointmentCancelRequested(appointment.id),
      );
    }
  }

  String _statusLabel(AppLocalizations l10n, AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.pending:
        return l10n.apptStatusPending;
      case AppointmentStatus.approved:
        return l10n.apptStatusConfirmed;
      case AppointmentStatus.rejected:
        return l10n.apptStatusRejected;
      case AppointmentStatus.inService:
        return l10n.apptStatusInService;
      case AppointmentStatus.completed:
        return l10n.apptStatusCompleted;
      case AppointmentStatus.cancelled:
        return l10n.apptStatusCancelled;
    }
  }

  Color _statusTextColor(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.pending:
        return AppColors.textPrimary;
      default:
        return AppColors.textOnPrimary;
    }
  }

  Color _statusColor(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.pending:
        return AppColors.pending;
      case AppointmentStatus.approved:
        return AppColors.success;
      case AppointmentStatus.rejected:
        return AppColors.danger;
      case AppointmentStatus.inService:
        return AppColors.pending;
      case AppointmentStatus.completed:
        return AppColors.infoStatus;
      case AppointmentStatus.cancelled:
        return AppColors.danger;
    }
  }

  String _formatDate(DateTime d) {
    const months = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';
    final parts = months.split(',');
    final month = parts[d.month - 1];
    return '$month ${d.day}, ${d.year}';
  }

  String _formatTime(DateTime d) {
    final h = d.hour;
    final m = d.minute;
    final am = h < 12;
    final hour = am ? (h == 0 ? 12 : h) : (h == 12 ? 12 : h - 12);
    return '${hour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} ${am ? 'AM' : 'PM'}';
  }
}

class _NearbyCentersSection extends StatelessWidget {
  const _NearbyCentersSection({required this.centers});

  final List<ServiceCenter> centers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (centers.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.svcNearbyCentersTitle,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            l10n.svcNoNearbyGarages,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.svcNearbyCentersTitle,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                l10n.commonViewAll,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        ...centers.map(
          (center) => Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
            child: _NearbyCenterCard(center: center),
          ),
        ),
      ],
    );
  }
}

class _NearbyCenterCard extends StatelessWidget {
  const _NearbyCenterCard({required this.center});

  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
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
                      center.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    GarageCenterStatusRow(center: center),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: AppColors.warning),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          center.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          ' (${center.reviewsCount})',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        InkWell(
                          onTap: () => _showReviewsSheet(context, center),
                          borderRadius: BorderRadius.circular(999),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              l10n.svcViewReviews,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          '${center.distanceMiles.toStringAsFixed(1)} mi',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (center.services.isNotEmpty) ...[
                      const SizedBox(height: Spacing.sm),
                      Wrap(
                        spacing: Spacing.xs,
                        runSpacing: Spacing.xs,
                        children: center.services.take(4).map((s) {
                          return ServiceTagChip(label: s.name);
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          GarageCenterCardFooter(
            center: center,
            onBook: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BookServiceWizardPage(center: center),
                ),
              );
            },
            onCall: () => _callCenter(context, center.phone),
            onRoute: () {
              Navigator.of(context).pushNamed(
                '/services/map',
                arguments: {'centerId': center.id, 'autoNavigate': true},
              );
            },
            onOnsite: () => _requestOnsite(context, center),
          ),
        ],
      ),
    );
  }

  static Future<void> _requestOnsite(
    BuildContext context,
    ServiceCenter center,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.mapOnsiteLocationBody)),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BookServiceWizardPage(
            center: center,
            isOnsite: true,
            serviceLatitude: pos.latitude,
            serviceLongitude: pos.longitude,
          ),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.mapOnsiteLocationBody)),
      );
    }
  }

  static Future<void> _callCenter(BuildContext context, String rawPhone) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final phone = rawPhone.trim();
    if (phone.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.svcNoPhone),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone);
    final ok = await canLaunchUrl(uri);
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.svcCallNotSupported),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _showReviewsSheet(
    BuildContext context,
    ServiceCenter center,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final sheetL10n = AppLocalizations.of(ctx)!;
        return FutureBuilder<_GarageReviewsPayload>(
          future: _fetchGarageReviews(center.id),
          builder: (ctx, snapshot) {
            final loading = snapshot.connectionState == ConnectionState.waiting;
            final hasError = snapshot.hasError;
            final payload = snapshot.data;
            final rating = payload?.averageRating ?? center.rating;
            final total = payload?.totalRatings ?? center.reviewsCount;
            final reviews = payload?.reviews ?? const <_GarageReviewItem>[];

            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.72,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.md,
                  Spacing.lg,
                  Spacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      center.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      sheetL10n.svcReviewsRatingTitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          sheetL10n.svcReviewCount(total),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.md),
                    if (loading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (hasError)
                      Expanded(
                        child: Center(
                          child: Text(
                            sheetL10n.svcReviewsLoadError,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      )
                    else if (reviews.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            sheetL10n.svcReviewsEmpty,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          itemCount: reviews.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final review = reviews[i];
                            final rawName = review.driverDisplayName.trim();
                            final displayName = rawName.isNotEmpty
                                ? rawName
                                : sheetL10n.svcReviewAnonymousDriver;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors.textPrimary,
                                    child: Text(
                                      review.initials,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                displayName,
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: Spacing.sm),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(5, (idx) {
                                                final filled =
                                                    idx < review.rating;
                                                return Icon(
                                                  filled
                                                      ? Icons.star_rounded
                                                      : Icons
                                                            .star_border_rounded,
                                                  size: 15,
                                                  color: filled
                                                      ? AppColors.warning
                                                      : AppColors.textSecondary,
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                review.comment.isEmpty
                                                    ? sheetL10n.svcReviewNoComment
                                                    : review.comment,
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: Spacing.sm),
                                            Text(
                                              _NearbyCenterCard._formatReviewDate(
                                                sheetL10n,
                                                review.createdAt,
                                              ),
                                              style: AppTextStyles.bodySmall
                                                  .copyWith(
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<_GarageReviewsPayload> _fetchGarageReviews(
    String garageId,
  ) async {
    final res = await getIt<ApiClient>().dio.get<Map<String, dynamic>>(
      ApiEndpoints.garageReviews(garageId),
    );
    final data = res.data ?? const <String, dynamic>{};
    final averageRaw = data['averageRating'];
    final totalRaw = data['totalRatings'];
    final reviewsRaw = data['reviews'];
    final reviews = <_GarageReviewItem>[];
    if (reviewsRaw is List) {
      for (final item in reviewsRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final driverMap = map['driver'] is Map
            ? Map<String, dynamic>.from(map['driver'] as Map)
            : const <String, dynamic>{};
        reviews.add(
          _GarageReviewItem(
            id: map['id']?.toString() ?? '',
            rating:
                ((map['rating'] is num) ? (map['rating'] as num).toInt() : 0)
                    .clamp(0, 5),
            comment: map['comment']?.toString() ?? '',
            createdAt:
                DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
                DateTime.fromMillisecondsSinceEpoch(0),
            driverFirstName: driverMap['firstName']?.toString() ?? '',
            driverLastName: driverMap['lastName']?.toString() ?? '',
          ),
        );
      }
    }
    return _GarageReviewsPayload(
      averageRating: averageRaw is num ? averageRaw.toDouble() : 0.0,
      totalRatings: totalRaw is num ? totalRaw.toInt() : 0,
      reviews: reviews,
    );
  }

  static String _formatReviewDate(AppLocalizations l10n, DateTime date) {
    if (date.millisecondsSinceEpoch == 0) return l10n.svcUnknownDate;
    const months = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';
    final parts = months.split(',');
    final month = parts[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }
}

class _GarageReviewsPayload {
  const _GarageReviewsPayload({
    required this.averageRating,
    required this.totalRatings,
    required this.reviews,
  });

  final double averageRating;
  final int totalRatings;
  final List<_GarageReviewItem> reviews;
}

class _GarageReviewItem {
  const _GarageReviewItem({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.driverFirstName,
    required this.driverLastName,
  });

  final String id;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String driverFirstName;
  final String driverLastName;

  String get driverDisplayName {
    return '$driverFirstName $driverLastName'.trim();
  }

  String get initials {
    final first = driverFirstName.trim().isNotEmpty
        ? driverFirstName.trim()[0].toUpperCase()
        : '';
    final last = driverLastName.trim().isNotEmpty
        ? driverLastName.trim()[0].toUpperCase()
        : '';
    final combined = '$first$last';
    if (combined.isNotEmpty) return combined;
    return 'D';
  }
}

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    AppLocalizations.of(context)!.svcMapView,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: Spacing.lg,
              bottom: Spacing.lg,
              child: Material(
                elevation: 2,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onTap,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.near_me_outlined,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
