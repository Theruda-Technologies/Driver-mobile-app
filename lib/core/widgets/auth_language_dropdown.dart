library;

import 'package:flutter/material.dart';

import '../constants/border_radius.dart';
import '../locale/app_locale_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

/// Compact language selector for auth screens (English / አማርኛ).
class AuthLanguageDropdown extends StatelessWidget {
  const AuthLanguageDropdown({super.key});

  String _effectiveCode(BuildContext context) {
    final saved = AppLocaleData.of(context).locale?.languageCode;
    if (saved == 'en' || saved == 'am') return saved!;
    final device = Localizations.localeOf(context).languageCode;
    return device == 'am' ? 'am' : 'en';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeData = AppLocaleData.of(context);
    final code = _effectiveCode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(BorderRadiusValues.md),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: code,
            isDense: true,
            alignment: AlignmentDirectional.centerEnd,
            icon: Icon(
              Icons.arrow_drop_down,
              color: AppColors.textSecondary,
            ),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            borderRadius: BorderRadius.circular(BorderRadiusValues.md),
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Text(l10n.authLanguageChipEnglish),
              ),
              DropdownMenuItem(
                value: 'am',
                child: Text(l10n.authLanguageChipAmharic),
              ),
            ],
            onChanged: (v) {
              if (v == null) return;
              localeData.setLocale(Locale(v));
            },
          ),
        ),
      ),
    );
  }
}
