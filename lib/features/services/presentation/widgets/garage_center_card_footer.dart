library;

import 'package:flutter/material.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/service_center.dart';
import 'garage_status_display.dart';

/// Book / call / route / on-site actions shared by list cards and map sheet.
class GarageCenterCardFooter extends StatelessWidget {
  const GarageCenterCardFooter({
    super.key,
    required this.center,
    required this.onBook,
    required this.onCall,
    required this.onRoute,
    this.onOnsite,
    this.bookButtonColor = AppColors.secondary,
  });

  final ServiceCenter center;
  final VoidCallback onBook;
  final VoidCallback onCall;
  final VoidCallback onRoute;
  final VoidCallback? onOnsite;
  final Color bookButtonColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onBook,
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: Text(l10n.svcBook),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bookButtonColor,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCall,
                icon: const Icon(Icons.phone_outlined, size: 18),
                label: Text(l10n.svcCall),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onRoute,
                icon: const Icon(Icons.near_me_outlined, size: 18),
                label: Text(l10n.svcRoute),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                ),
              ),
            ),
          ],
        ),
        if (center.onsiteServiceEnabled) ...[
          const SizedBox(height: Spacing.sm),
          OutlinedButton.icon(
            onPressed: center.canRequestOnsite ? onOnsite : null,
            icon: const Icon(Icons.home_repair_service_outlined, size: 18),
            label: Text(l10n.mapRequestOnsite),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: center.canRequestOnsite
                    ? AppColors.primary
                    : AppColors.border,
              ),
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
            ),
          ),
        ],
      ],
    );
  }
}

/// Status line + optional on-site hint (same on every garage card).
class GarageCenterStatusRow extends StatelessWidget {
  const GarageCenterStatusRow({super.key, required this.center});

  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GarageStatusDisplay.label(l10n, center),
          style: AppTextStyles.bodySmall.copyWith(
            color: GarageStatusDisplay.textColor(center),
            fontWeight: FontWeight.w500,
          ),
        ),
        if (center.onsiteServiceEnabled) ...[
          const SizedBox(height: 2),
          Text(
            l10n.svcOnsiteAvailable,
            style: AppTextStyles.labelSmall.copyWith(
              color: center.canRequestOnsite
                  ? AppColors.success
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
