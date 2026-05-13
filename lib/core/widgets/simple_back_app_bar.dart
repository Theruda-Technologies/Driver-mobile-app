library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Minimal app bar: back + optional title (e.g. secondary / pushed screens).
class SimpleBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleBackAppBar({
    super.key,
    this.title,
    this.backgroundColor = AppColors.background,
    this.foregroundColor = AppColors.textPrimary,
    this.leadingIcon = Icons.arrow_back,
    this.onBackPressed,
  });

  final Widget? title;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData leadingIcon;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      foregroundColor: foregroundColor,
      leading: IconButton(
        icon: Icon(leadingIcon),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: title,
    );
  }
}

/// [SimpleBackAppBar] with title text using [AppTextStyles.titleMedium].
class SimpleBackTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleBackTitleAppBar({
    super.key,
    required this.titleText,
    this.backgroundColor = AppColors.background,
    this.foregroundColor = AppColors.textPrimary,
    this.leadingIcon = Icons.arrow_back,
    this.onBackPressed,
    this.fontWeight = FontWeight.w700,
  });

  final String titleText;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData leadingIcon;
  final VoidCallback? onBackPressed;
  final FontWeight fontWeight;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SimpleBackAppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      leadingIcon: leadingIcon,
      onBackPressed: onBackPressed,
      title: Text(
        titleText,
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: fontWeight,
          color: foregroundColor,
        ),
      ),
    );
  }
}
