import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/border_radius.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/driver_shell_bottom_nav_bar.dart';
import '../../../../core/widgets/nav_app_bar.dart';
import '../../../../injection/service_locator.dart';
import '../../../appointments/domain/entities/appointment.dart';
import '../../../appointments/presentation/bloc/appointments_bloc.dart';
import '../../../appointments/presentation/bloc/appointments_event.dart';
import '../../../appointments/presentation/bloc/appointments_state.dart';
import '../../domain/entities/service_center.dart';
import '../widgets/service_text_formatter.dart';

class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({
    super.key,
    this.centers = const [],
  });

  final List<ServiceCenter> centers;

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AppointmentsBloc>()..add(const AppointmentsLoadRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: const AppDrawer(currentRoute: '/services'),
        appBar: NavAppBar.mainShell(context),
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

              final upcoming = appointments
                  .where((a) =>
                      a.status != AppointmentStatus.rejected &&
                      a.status != AppointmentStatus.completed)
                  .toList();

              final l10n = AppLocalizations.of(context)!;

              if (upcoming.isEmpty) {
                return Center(
                  child: Text(
                    l10n.svcNoAppointmentsFound,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.lg,
                      Spacing.md,
                      Spacing.lg,
                      Spacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.svcApptsListTitle,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          l10n.svcApptsListSubtitle,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                        vertical: Spacing.lg,
                      ),
                      itemCount: upcoming.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.sm),
                          child: _AppointmentCardFromEntity(
                            appointment: upcoming[index],
                            centers: widget.centers,
                          ),
                        );
                      },
                    ),
                  ),
                ],
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String garageNameResolved;
    try {
      garageNameResolved = centers.firstWhere((c) => c.id == appointment.garageId).name;
    } catch (_) {
      garageNameResolved = l10n.commonGarage;
    }
    final statusLabel = _statusLabel(l10n, appointment.status);
    final statusColor = _statusColor(appointment.status);
    final dateStr = _formatDate(appointment.scheduledAt);
    final timeStr = _formatTime(appointment.scheduledAt);

    final garageName = appointment.garageName ?? garageNameResolved;
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
              const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: Spacing.xs),
              Text(dateStr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(width: Spacing.md),
              const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: Spacing.xs),
              Text(timeStr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: Spacing.md),
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
                  child: Text(l10n.svcReschedule),
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
                  child: Text(l10n.svcCancel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          AppointmentRescheduleRequested(id: appointment.id, scheduledAt: scheduledAt),
        );
  }

  Future<void> _onCancel(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final loc = AppLocalizations.of(ctx)!;
        return AlertDialog(
        title: Text(loc.apptCancelTitle),
        content: Text(loc.apptCancelBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(loc.commonNo),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(loc.commonYes, style: TextStyle(color: AppColors.danger)),
          ),
        ],
      );
      },
    );

    if (confirm == true && context.mounted) {
      context.read<AppointmentsBloc>().add(AppointmentCancelRequested(appointment.id));
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
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.rejected:
        return AppColors.danger;
      case AppointmentStatus.inService:
        return AppColors.info;
      case AppointmentStatus.cancelled:
        return AppColors.textSecondary;
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
