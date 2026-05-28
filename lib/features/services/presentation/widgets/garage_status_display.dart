library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/service_center.dart';

/// Labels for garage open / book-ahead / closed (avoids "Closed" when booking works).
class GarageStatusDisplay {
  GarageStatusDisplay._();

  static String label(AppLocalizations l10n, ServiceCenter center) {
    if (center.isOpenNow) return l10n.svcOpen;
    // Registered garages accept bookings even when hours are not loaded on the card.
    if (center.acceptsBookings) return l10n.svcBookAhead;
    return l10n.svcClosed;
  }

  static Color accentColor(ServiceCenter center) {
    if (center.isOpenNow) return AppColors.success;
    if (center.acceptsBookings) return AppColors.secondary;
    return AppColors.danger;
  }

  static Color? textColor(ServiceCenter center) {
    if (center.isOpenNow) return AppColors.success;
    if (center.acceptsBookings) return AppColors.secondary;
    return AppColors.textSecondary;
  }
}

/// Pill badge (map bottom sheet).
class GarageStatusChip extends StatelessWidget {
  const GarageStatusChip({super.key, required this.center});

  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bg = GarageStatusDisplay.accentColor(center);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        GarageStatusDisplay.label(l10n, center),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
