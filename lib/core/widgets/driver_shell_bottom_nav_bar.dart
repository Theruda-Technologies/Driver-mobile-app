library;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../constants/dimensions.dart';
import '../constants/spacing.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Primary shell destinations (bottom navigation).
enum DriverShellTab {
  home,
  vehicles,
  service,
  community,
  education,
}

/// Shared bottom bar for dashboard, vehicles, service, community, and education flows.
class DriverShellBottomNavBar extends StatelessWidget {
  const DriverShellBottomNavBar({
    super.key,
    required this.current,
    this.educationNavMode = EducationNavMode.pushNamed,
  });

  final DriverShellTab current;

  /// How the Education tab navigates when not already active.
  final EducationNavMode educationNavMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: AppColors.surface,
      elevation: 0,
      child: SizedBox(
        height: Dimensions.bottomNavHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShellNavItem(
                icon: Icons.home_filled,
                label: l10n.navHome,
                active: current == DriverShellTab.home,
                onTap: current == DriverShellTab.home
                    ? null
                    : () => Navigator.of(context).pushNamedAndRemoveUntil(
                          '/driver-dashboard',
                          (route) => route.isFirst,
                        ),
              ),
              _ShellNavItem(
                icon: Icons.directions_car_filled,
                label: l10n.navVehicles,
                active: current == DriverShellTab.vehicles,
                onTap: current == DriverShellTab.vehicles
                    ? null
                    : () => Navigator.of(context).pushNamed('/vehicles'),
              ),
              _ShellNavItem(
                icon: Icons.handyman_outlined,
                label: l10n.navService,
                active: current == DriverShellTab.service,
                onTap: current == DriverShellTab.service
                    ? null
                    : () => Navigator.of(context).pushNamed('/services'),
              ),
              _ShellNavItem(
                icon: Icons.people_alt_outlined,
                label: l10n.navCommunity,
                active: current == DriverShellTab.community,
                onTap: current == DriverShellTab.community
                    ? null
                    : () => Navigator.of(context).pushNamed('/community'),
              ),
              _ShellNavItem(
                icon: Icons.menu_book_outlined,
                label: l10n.navEduShort,
                active: current == DriverShellTab.education,
                onTap: current == DriverShellTab.education
                    ? null
                    : () {
                        switch (educationNavMode) {
                          case EducationNavMode.pushNamed:
                            Navigator.of(context).pushNamed('/education');
                            break;
                          case EducationNavMode.pushReplacement:
                            Navigator.of(context).pushReplacementNamed('/education');
                            break;
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum EducationNavMode {
  /// Stack `/education` like other shell tabs.
  pushNamed,

  /// Replace current route (used by education sub-screens when switching to the education tab).
  pushReplacement,
}

class _ShellNavItem extends StatelessWidget {
  const _ShellNavItem({
    required this.icon,
    required this.label,
    required this.active,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.textPrimary : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: Spacing.xs),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}
