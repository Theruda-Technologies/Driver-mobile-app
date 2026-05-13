library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/nav_app_bar.dart';
import '../../../../injection/service_locator.dart';
import '../../../vehicles/presentation/bloc/vehicles_bloc.dart';
import '../../../vehicles/presentation/bloc/vehicles_event.dart';
import '../bloc/maintenance_bloc.dart';
import '../bloc/maintenance_event.dart';
import '../bloc/maintenance_state.dart';
import '../widgets/maintenance_upcoming_list_item.dart';
import 'schedule_maintenance_page.dart';

class MaintenanceUpcomingPage extends StatefulWidget {
  const MaintenanceUpcomingPage({super.key});

  @override
  State<MaintenanceUpcomingPage> createState() => _MaintenanceUpcomingPageState();
}

class _MaintenanceUpcomingPageState extends State<MaintenanceUpcomingPage> {
  @override
  void initState() {
    super.initState();
    context.read<MaintenanceBloc>().add(const MaintenanceLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    if (_maybeVehiclesBloc(context) == null) {
      return BlocProvider(
        create: (_) => getIt<VehiclesBloc>()..add(const VehiclesLoadRequested()),
        child: Builder(builder: (context) => _buildScaffold(context)),
      );
    }
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NavAppBar.mainShell(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Maintenance',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Scheduled and recommended services',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
              Expanded(
                child: BlocBuilder<MaintenanceBloc, MaintenanceState>(
                  builder: (context, state) {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final active = state.upcoming.where((u) => u.isActiveReminder).toList();
                    active.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
                    final overdue = <dynamic>[];
                    final upcoming = <dynamic>[];
                    for (final u in active) {
                      final d = DateTime(u.scheduledAt.year, u.scheduledAt.month, u.scheduledAt.day);
                      if (d.isBefore(today)) {
                        overdue.add(u);
                      } else {
                        upcoming.add(u);
                      }
                    }
                    if (state.loading && active.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (active.isEmpty) {
                      return Center(
                        child: Text(
                          'No upcoming maintenance.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    final rows = <Widget>[];
                    if (overdue.isNotEmpty) {
                      rows.add(
                        Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.sm),
                          child: Text(
                            'Past due',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                      for (final u in overdue.cast()) {
                        rows.add(
                          MaintenanceUpcomingListItem(
                            item: u,
                            onDelete: () => context.read<MaintenanceBloc>().add(
                                  MaintenanceUpcomingDeleteRequested(u.id),
                                ),
                            onToggleReminder: () => context.read<MaintenanceBloc>().add(
                                  MaintenanceToggleReminderRequested(u.id),
                                ),
                            onMarkDone: u.canMarkDoneFromUi
                                ? () => context.read<MaintenanceBloc>().add(
                                      MaintenanceMarkDoneRequested(u.id),
                                    )
                                : null,
                          ),
                        );
                        rows.add(const SizedBox(height: Spacing.md));
                      }
                    }
                    if (upcoming.isNotEmpty) {
                      if (rows.isNotEmpty) rows.add(const SizedBox(height: Spacing.xs));
                      rows.add(
                        Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.sm),
                          child: Text(
                            'Upcoming',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                      for (final u in upcoming.cast()) {
                        rows.add(
                          MaintenanceUpcomingListItem(
                            item: u,
                            onDelete: () => context.read<MaintenanceBloc>().add(
                                  MaintenanceUpcomingDeleteRequested(u.id),
                                ),
                            onToggleReminder: () => context.read<MaintenanceBloc>().add(
                                  MaintenanceToggleReminderRequested(u.id),
                                ),
                            onMarkDone: u.canMarkDoneFromUi
                                ? () => context.read<MaintenanceBloc>().add(
                                      MaintenanceMarkDoneRequested(u.id),
                                    )
                                : null,
                          ),
                        );
                        rows.add(const SizedBox(height: Spacing.md));
                      }
                    }
                    if (rows.isNotEmpty && rows.last is SizedBox) {
                      rows.removeLast();
                    }
                    return ListView(
                      children: rows,
                    );
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
                  label: Text(AppLocalizations.of(context)!.maintSetReminder),
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
          ),
        ),
      ),
    );
  }

  // Vehicle picking now happens on the dedicated schedule screen.
}

VehiclesBloc? _maybeVehiclesBloc(BuildContext context) {
  try {
    return BlocProvider.of<VehiclesBloc>(context);
  } catch (_) {
    return null;
  }
}

