library;

import 'package:flutter/material.dart';

import '../../../../core/widgets/driver_shell_bottom_nav_bar.dart';

/// Alias for [DriverShellTab] (education module).
typedef EducationShellTab = DriverShellTab;

/// Education shell bottom bar; uses replacement when opening the Education tab
/// from another shell tab (same behavior as the previous standalone widget).
class EducationBottomNavBar extends StatelessWidget {
  const EducationBottomNavBar({super.key, required this.current});

  final EducationShellTab current;

  @override
  Widget build(BuildContext context) {
    return DriverShellBottomNavBar(
      current: current,
      educationNavMode: EducationNavMode.pushReplacement,
    );
  }
}
