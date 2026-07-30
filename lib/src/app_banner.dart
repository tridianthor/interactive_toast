import 'package:flutter/material.dart';
import 'app_banner_controller.dart';

/// InheritedWidget wrapper for AppBannerController
class AppBanner extends InheritedWidget {
  final AppBannerController controller;

  const AppBanner({
    super.key,
    required this.controller,
    required super.child,
  });

  static AppBannerController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppBanner>();
    return provider?.controller ?? AppBannerController();
  }

  @override
  bool updateShouldNotify(AppBanner oldWidget) {
    return controller != oldWidget.controller;
  }
}
