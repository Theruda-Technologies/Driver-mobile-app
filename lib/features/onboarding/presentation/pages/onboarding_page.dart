import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _prefsKey = 'onboarding_v2_completed';

  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<_OnboardingContent> _pages(AppLocalizations l10n) => [
        _OnboardingContent(
          imageAsset: 'assets/images/onboarding_car_health.png',
          title: l10n.onbTitle1,
          body: l10n.onbBody1,
        ),
        _OnboardingContent(
          imageAsset: 'assets/images/onboarding_maintenance.png',
          title: l10n.onbTitle2,
          body: l10n.onbBody2,
        ),
        _OnboardingContent(
          imageAsset: 'assets/images/onboarding_help.png',
          title: l10n.onbTitle3,
          body: l10n.onbBody3,
        ),
        _OnboardingContent(
          imageAsset: 'assets/images/onboarding_ai_assistant.png',
          title: l10n.onbTitle4,
          body: l10n.onbBody4,
        ),
        _OnboardingContent(
          imageAsset: 'assets/images/onboarding_learn_share.png',
          title: l10n.onbTitle5,
          body: l10n.onbBody5,
        ),
        _OnboardingContent(
          title: l10n.onbTitle6,
          body: l10n.onbBody6,
        ),
      ];

  Future<void> _setCompletedAndContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, true);
    if (!mounted) return;
    _goToApp();
  }

  void _goToApp() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _onNext() {
    final pages = _pages(AppLocalizations.of(context)!);
    if (_currentPage == pages.length - 1) {
      _setCompletedAndContinue();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onSkip() {
    _setCompletedAndContinue();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _pages(l10n);
    final isLast = _currentPage == pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  _PageDots(count: pages.length, index: _currentPage),
                  const Spacer(),
                  TextButton(
                    onPressed: _onSkip,
                    child: Text(
                      l10n.onbSkip,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        if (page.imageAsset.isNotEmpty)
                          SizedBox(
                            height: 260,
                            child: Image.asset(
                              page.imageAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        const SizedBox(height: 24),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _onNext,
                  child: Text(isLast ? l10n.onbGetStarted : l10n.commonContinue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
    this.imageAsset = '',
    required this.title,
    required this.body,
  });

  final String imageAsset;
  final String title;
  final String body;
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
