import 'package:flutter/material.dart';
import '../banner_type.dart';

/// Style utilities for resolving banner colors and decorations
class BannerStyle {
  BannerStyle._();

  /// Border radius for banner container
  static const double borderRadius = 12.0;

  /// Shadow elevation for floating appearance
  static const double shadowElevation = 4.0;

  /// Horizontal padding inside banner
  static const double horizontalPadding = 16.0;

  /// Vertical padding inside banner
  static const double verticalPadding = 12.0;

  /// Resolve color from BannerType to ColorScheme
  static Color resolveColor(BuildContext context, BannerType type) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case BannerType.info:
        return colorScheme.primary;
      case BannerType.success:
        return colorScheme.primary;
      case BannerType.warning:
        return colorScheme.tertiary;
      case BannerType.error:
        return colorScheme.error;
    }
  }

  /// Build BoxDecoration with rounded corners and shadow
  static BoxDecoration buildDecoration({
    required Color backgroundColor,
    double radius = borderRadius,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
