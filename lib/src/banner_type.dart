import 'package:flutter/material.dart';

/// Semantic banner types with associated default icons
enum BannerType {
  info(Icons.info_outline),
  success(Icons.check_circle_outline),
  warning(Icons.warning_amber_outlined),
  error(Icons.error_outline);

  final IconData defaultIcon;
  const BannerType(this.defaultIcon);
}
