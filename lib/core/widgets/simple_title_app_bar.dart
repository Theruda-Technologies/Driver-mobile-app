library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// App bar with a single title and no leading control (e.g. hub sub-lists).
class SimpleTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleTitleAppBar({
    super.key,
    required this.title,
    this.backgroundColor = AppColors.background,
    this.foregroundColor = AppColors.textPrimary,
  });

  final Widget title;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 0,
      foregroundColor: foregroundColor,
      title: title,
    );
  }
}
