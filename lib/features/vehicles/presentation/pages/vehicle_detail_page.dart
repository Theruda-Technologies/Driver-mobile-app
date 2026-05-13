library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/border_radius.dart';
import '../../../../core/widgets/driver_shell_bottom_nav_bar.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection/service_locator.dart';
import '../../../maintenance/application/usecases/get_vehicle_health_usecase.dart';
import '../../../maintenance/domain/entities/vehicle_health.dart';
import '../../../maintenance/presentation/utils/vehicle_health_ui.dart';
import '../../../maintenance/presentation/widgets/vehicle_health_subsystems_strip.dart';
import '../../domain/entities/vehicle.dart';
import '../bloc/vehicles_bloc.dart';
import '../bloc/vehicles_event.dart';
import '../bloc/vehicles_state.dart';

class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VehiclesBloc>()..add(VehicleDetailRequested(vehicleId)),
      child: _VehicleDetailView(vehicleId: vehicleId),
    );
  }
}

class _VehicleDetailView extends StatelessWidget {
  const _VehicleDetailView({required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehiclesBloc, VehiclesState>(
      listenWhen: (prev, curr) => curr is VehicleDeleted || curr is VehiclesFailure,
      listener: (context, state) {
        if (state is VehicleDeleted) {
          final l10n = AppLocalizations.of(context)!;
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.vehDetailRemoved),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BlocBuilder<VehiclesBloc, VehiclesState>(
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            if (state is! VehicleDetailLoaded) {
              return Text(
                l10n.vehDetailTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              );
            }
            final v = state.vehicle;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  v.displayName,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  v.plateNumber,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<VehiclesBloc, VehiclesState>(
        builder: (context, state) {
          if (state is VehiclesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VehiclesFailure) {
            final l10n = AppLocalizations.of(context)!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppColors.danger),
                    const SizedBox(height: Spacing.md),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: Spacing.lg),
                    TextButton(
                      onPressed: () => context.read<VehiclesBloc>().add(VehicleDetailRequested(vehicleId)),
                      child: Text(l10n.commonRetry),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is! VehicleDetailLoaded) {
            return const SizedBox.shrink();
          }
          final l10n = AppLocalizations.of(context)!;
          final vehicle = state.vehicle;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImagePlaceholder(),
                const SizedBox(height: Spacing.lg),
                _OverallHealthCard(vehicleId: vehicle.id),
                const SizedBox(height: Spacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RouteNames.aiChat,
                        arguments: {'vehicleId': vehicle.id},
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 20),
                    label: Text(l10n.vehDetailAskAi),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.secondary),
                      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                _VehicleInformationCard(vehicle: vehicle),
                const SizedBox(height: Spacing.lg),
                _DocumentsCard(
                  insuranceDocumentUrl: vehicle.insuranceDocumentUrl,
                  insuranceExpiresAt: vehicle.insuranceExpiresAt,
                  registrationDocumentUrl: vehicle.registrationDocumentUrl,
                  registrationExpiresAt: vehicle.registrationExpiresAt,
                ),
                const SizedBox(height: Spacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).pushNamed(
                        '/vehicles/edit',
                        arguments: vehicle,
                      );
                      if (context.mounted) {
                        context.read<VehiclesBloc>().add(VehicleDetailRequested(vehicleId));
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: Text(l10n.vehDetailEditVehicle),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmRemove(context, vehicle),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: Text(l10n.vehDetailRemoveVehicle),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.bottomNavHeight + Spacing.lg),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const DriverShellBottomNavBar(current: DriverShellTab.vehicles),
    ),
    );
  }

  Future<void> _confirmRemove(BuildContext context, Vehicle vehicle) async {
    final display =
        vehicle.displayName.trim().isNotEmpty ? vehicle.displayName.trim() : vehicle.plateNumber;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dL10n.vehDetailRemoveTitle),
          content: Text(dL10n.vehDetailRemoveConfirmBody(display)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(dL10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(dL10n.commonRemove, style: TextStyle(color: AppColors.danger)),
            ),
          ],
        );
      },
    );
    if (confirm == true && context.mounted) {
      context.read<VehiclesBloc>().add(VehicleDeleteRequested(vehicle.id));
    }
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
      ),
      child: Icon(Icons.directions_car_outlined, size: 64, color: AppColors.textSecondary),
    );
  }
}

class _OverallHealthCard extends StatefulWidget {
  const _OverallHealthCard({required this.vehicleId});

  final String vehicleId;

  @override
  State<_OverallHealthCard> createState() => _OverallHealthCardState();
}

class _OverallHealthCardState extends State<_OverallHealthCard> {
  VehicleHealth? _health;
  bool _loading = true;
  Object? _error;

  Future<void> _load() async {
    final vid = widget.vehicleId;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final health = await getIt<GetVehicleHealthUseCase>()(vid);
      if (!mounted || widget.vehicleId != vid) return;
      setState(() {
        _health = health;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _health = null;
        _loading = false;
        _error = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _OverallHealthCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vehicleId != widget.vehicleId) {
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const Center(child: Padding(padding: EdgeInsets.all(Spacing.lg), child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.vehDetailHealthUnavailable,
              style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              l10n.vehDetailHealthRetryHint,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            TextButton(onPressed: _load, child: Text(l10n.commonRetry)),
          ],
        ),
      );
    }
    final h = _health ?? const VehicleHealth(overallPercent: 0);
    final pct = h.overallPercent.clamp(0, 100);
    final color = vehicleHealthColorForPercent(pct);
    final subsystems = orderedHealthComponents(h.components);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OverallHealthCardBody(
          percentage: pct,
          color: color,
          subtitle: (h.summary != null && h.summary!.trim().isNotEmpty)
              ? h.summary!.trim()
              : l10n.dashHealthScoresFallback,
        ),
        if (subsystems.isNotEmpty) ...[
          const SizedBox(height: Spacing.md),
          VehicleHealthSubsystemsStrip(components: subsystems),
        ],
      ],
    );
  }
}

class _OverallHealthCardBody extends StatelessWidget {
  const _OverallHealthCardBody({
    required this.percentage,
    required this.color,
    this.subtitle,
  });
  final int percentage;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.dashOverallCarHealthTitle,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.xs),
            Text(
              subtitle!.trim(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.35),
            ),
          ],
        ],
      ),
    );
  }
}

class _VehicleInformationCard extends StatelessWidget {
  const _VehicleInformationCard({required this.vehicle});

  final Vehicle vehicle;

  static String _formatMileage(int n) {
    if (n < 1000) return n.toString();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mileageStr = vehicle.mileage != null
        ? '${_formatMileage(vehicle.mileage!)} ${l10n.commonMilesUnit}'
        : l10n.commonEmDash;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.vehDetailVehicleInformation,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.md),
          _InfoRow(icon: Icons.directions_car_outlined, label: l10n.vehDetailMakeModel, value: '${vehicle.make} ${vehicle.model}'),
          _InfoRow(icon: Icons.calendar_today_outlined, label: l10n.vehDetailYear, value: vehicle.year.toString()),
          _InfoRow(icon: Icons.description_outlined, label: l10n.vehDetailVin, value: vehicle.vin ?? l10n.commonEmDash),
          _InfoRow(icon: Icons.speed_outlined, label: l10n.vehDetailMileage, value: mileageStr),
          _InfoRow(icon: Icons.local_gas_station_outlined, label: l10n.vehDetailFuelType, value: vehicle.fuelType ?? l10n.commonEmDash),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentsCard extends StatelessWidget {
  const _DocumentsCard({
    this.insuranceDocumentUrl,
    this.insuranceExpiresAt,
    this.registrationDocumentUrl,
    this.registrationExpiresAt,
  });

  final String? insuranceDocumentUrl;
  final DateTime? insuranceExpiresAt;
  final String? registrationDocumentUrl;
  final DateTime? registrationExpiresAt;

  static String _formatDate(DateTime d) {
    const months = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';
    return '${months.split(',')[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final insuranceText = insuranceExpiresAt != null
        ? l10n.vehDetailInsuranceActiveExpires(_formatDate(insuranceExpiresAt!))
        : l10n.commonEmDash;
    final registrationText = registrationExpiresAt != null
        ? l10n.vehDetailRegistrationValidExpires(_formatDate(registrationExpiresAt!))
        : l10n.commonEmDash;

    final hasInsuranceDoc = (insuranceDocumentUrl ?? '').trim().isNotEmpty;
    final hasRegistrationDoc = (registrationDocumentUrl ?? '').trim().isNotEmpty;
    final hasAnyDoc = hasInsuranceDoc || hasRegistrationDoc;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(BorderRadiusValues.xl),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.vehDetailDocumentsSection,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.vehDetailInsurance, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                    Text(insuranceText, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Icon(Icons.description_outlined, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.vehDetailRegistration, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                    Text(registrationText, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: hasAnyDoc
                  ? () => _showDocumentsSheet(
                        context,
                        insuranceUrl: hasInsuranceDoc ? insuranceDocumentUrl!.trim() : null,
                        registrationUrl:
                            hasRegistrationDoc ? registrationDocumentUrl!.trim() : null,
                      )
                  : null,
              icon: const Icon(Icons.folder_open_outlined, size: 18),
              label: Text(l10n.vehDetailViewDocuments),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.secondary),
                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _showDocumentsSheet(
    BuildContext context, {
    required String? insuranceUrl,
    required String? registrationUrl,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final sheetL10n = AppLocalizations.of(ctx)!;
        Future<void> open(String url) async {
          final uri = Uri.tryParse(url);
          if (uri == null) return;
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheetL10n.vehDetailDocumentsSection,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                if (insuranceUrl != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.shield_outlined),
                    title: Text(sheetL10n.vehDetailInsuranceDoc),
                    subtitle: Text(
                      insuranceUrl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => open(insuranceUrl),
                  ),
                if (registrationUrl != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined),
                    title: Text(sheetL10n.vehDetailRegistrationDoc),
                    subtitle: Text(
                      registrationUrl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => open(registrationUrl),
                  ),
                if (insuranceUrl == null && registrationUrl == null)
                  Text(
                    sheetL10n.vehDetailNoDocumentsAvailable,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
