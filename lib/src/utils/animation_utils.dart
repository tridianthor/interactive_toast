import 'package:flutter/material.dart';

/// Animation constants and utilities for banner transitions
class AnimationUtils {
  AnimationUtils._();

  /// Default animation curve for natural deceleration
  static const Curve defaultCurve = Curves.easeOutCubic;

  /// Entry/exit animation duration
  static const Duration transitionDuration = Duration(milliseconds: 300);

  /// Vertical displacement threshold for swipe-to-dismiss (pixels)
  static const double swipeDismissThreshold = 100.0;

  /// Minimum velocity threshold for swipe dismiss (pixels/second)
  static const double swipeVelocityThreshold = 500.0;
}
