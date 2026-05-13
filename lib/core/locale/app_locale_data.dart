library;

import 'package:flutter/material.dart';

/// Holds the active app [locale] and [setLocale] for persistence + rebuild.
class AppLocaleData extends InheritedWidget {
  const AppLocaleData({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  final Locale? locale;
  final Future<void> Function(Locale locale) setLocale;

  static AppLocaleData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleData>();
    assert(scope != null, 'AppLocaleData not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant AppLocaleData oldWidget) {
    return oldWidget.locale != locale;
  }
}
