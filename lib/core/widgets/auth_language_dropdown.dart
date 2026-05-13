library;

import 'package:flutter/material.dart';

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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: code,
          alignment: AlignmentDirectional.centerEnd,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.textSecondary,
          ),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          borderRadius: BorderRadius.circular(8),
          items: [
            DropdownMenuItem(
              value: 'en',
              child: Text(l10n.settingsLanguageEnglish),
            ),
            DropdownMenuItem(
              value: 'am',
              child: Text(l10n.settingsLanguageAmharic),
            ),
          ],
          onChanged: (v) {
            if (v == null) return;
            localeData.setLocale(Locale(v));
          },
        ),
      ),
    );
  }
}
