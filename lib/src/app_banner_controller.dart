import 'package:flutter/material.dart';
import 'app_banner_entry.dart';

/// Controller singleton for managing banner display
class AppBannerController {
  static AppBannerController? _instance;
  AppBannerEntry? _currentEntry;

  AppBannerController._();

  factory AppBannerController() {
    _instance ??= AppBannerController._();
    return _instance!;
  }

  /// Get singleton instance
  static AppBannerController of(BuildContext context) {
    return AppBannerController();
  }

  /// Show a banner with the given config
  void show(BuildContext context, BannerConfig config) {
    _currentEntry?.dismiss();
    _currentEntry = AppBannerEntry(config: config);
    _currentEntry!.show(context);
  }

  /// Dismiss the current banner
  void dismiss() {
    _currentEntry?.dismiss();
    _currentEntry = null;
  }
}
