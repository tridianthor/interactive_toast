import 'package:flutter/material.dart';

/// Configuration for inline action button
class BannerAction {
  final String label;
  final VoidCallback onTap;

  const BannerAction({
    required this.label,
    required this.onTap,
  });
}
