library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/border_radius.dart';
import '../../../../core/constants/spacing.dart';
import '../../../../core/locale/app_locale_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../injection/service_locator.dart';
import '../../application/usecases/change_password_usecase.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _submitting = false;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_submitting) return;
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _submitting = true);
    try {
      await getIt<ChangePasswordUseCase>().call(
        currentPassword: _currentPasswordCtrl.text.trim(),
        newPassword: _newPasswordCtrl.text.trim(),
      );
      if (!mounted) return;
      _currentPasswordCtrl.clear();
      _newPasswordCtrl.clear();
      _confirmPasswordCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.settingsPasswordChanged)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_message(e, AppLocalizations.of(context)!)),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _message(Object e, AppLocalizations l10n) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['error'] != null) return data['error'].toString();
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return e.message ?? l10n.settingsRequestFailed;
    }
    final text = e.toString();
    if (text.length < 140) return text;
    return l10n.settingsUnableChangePassword;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final localeData = AppLocaleData.of(context);
        final selectedCode = localeData.locale?.languageCode;
        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: const AppDrawer(currentRoute: '/settings'),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              l10n.settingsTitle,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.settingsLanguageSection,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BorderRadiusValues.lg),
                      side: const BorderSide(color: AppColors.surfaceMuted),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(l10n.settingsLanguageEnglish),
                          trailing: selectedCode == 'en'
                              ? const Icon(Icons.check, color: AppColors.primary)
                              : null,
                          onTap: () => localeData.setLocale(const Locale('en')),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: Text(l10n.settingsLanguageAmharic),
                          trailing: selectedCode == 'am'
                              ? const Icon(Icons.check, color: AppColors.primary)
                              : null,
                          onTap: () => localeData.setLocale(const Locale('am')),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                  Text(
                    l10n.settingsChangePasswordTitle,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    l10n.settingsChangePasswordSubtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  _buildPasswordField(
                    controller: _currentPasswordCtrl,
                    label: l10n.settingsCurrentPasswordLabel,
                    obscure: !_showCurrent,
                    onToggle: () => setState(() => _showCurrent = !_showCurrent),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.settingsValidatorCurrentRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.md),
                  _buildPasswordField(
                    controller: _newPasswordCtrl,
                    label: l10n.settingsNewPasswordLabel,
                    obscure: !_showNew,
                    onToggle: () => setState(() => _showNew = !_showNew),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return l10n.settingsValidatorNewRequired;
                      if (v.length < 6) {
                        return l10n.settingsValidatorNewMin6;
                      }
                      if (v == _currentPasswordCtrl.text.trim()) {
                        return l10n.settingsValidatorNewDifferent;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.md),
                  _buildPasswordField(
                    controller: _confirmPasswordCtrl,
                    label: l10n.settingsConfirmNewPasswordLabel,
                    obscure: !_showConfirm,
                    onToggle: () => setState(() => _showConfirm = !_showConfirm),
                    validator: (value) {
                      if ((value?.trim() ?? '').isEmpty) {
                        return l10n.settingsValidatorConfirmRequired;
                      }
                      if (value!.trim() != _newPasswordCtrl.text.trim()) {
                        return l10n.settingsValidatorPasswordsMismatch;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            BorderRadiusValues.button,
                          ),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.settingsUpdatePasswordButton,
                              style: AppTextStyles.buttonMedium.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(height: Spacing.xs),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            hintText: label,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
