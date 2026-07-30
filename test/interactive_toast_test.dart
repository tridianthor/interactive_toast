import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interactive_toast/interactive_toast.dart';

void main() {
  group('BannerConfig', () {
    test('creates with required message', () {
      final config = BannerConfig(message: 'Test message');
      expect(config.message, 'Test message');
      expect(config.type, BannerType.info);
      expect(config.duration, const Duration(seconds: 3));
      expect(config.showProgress, false);
    });

    test('creates with custom type', () {
      final config = BannerConfig(
        message: 'Error occurred',
        type: BannerType.error,
      );
      expect(config.type, BannerType.error);
    });

    test('creates with custom icon', () {
      final config = BannerConfig(
        message: 'Custom icon',
        icon: Icons.star,
      );
      expect(config.icon, Icons.star);
    });

    test('creates with custom duration', () {
      final config = BannerConfig(
        message: 'Longer toast',
        duration: const Duration(seconds: 5),
      );
      expect(config.duration, const Duration(seconds: 5));
    });

    test('creates with progress indicator', () {
      final config = BannerConfig(
        message: 'With progress',
        showProgress: true,
      );
      expect(config.showProgress, true);
    });

    test('creates with action button', () {
      var tapped = false;
      final config = BannerConfig(
        message: 'With action',
        action: BannerAction(
          label: 'Undo',
          onTap: () => tapped = true,
        ),
      );
      expect(config.action?.label, 'Undo');
      config.action?.onTap();
      expect(tapped, true);
    });
  });

  group('BannerType', () {
    test('info has info icon', () {
      expect(BannerType.info.defaultIcon, Icons.info_outline);
    });

    test('success has check icon', () {
      expect(BannerType.success.defaultIcon, Icons.check_circle_outline);
    });

    test('warning has warning icon', () {
      expect(BannerType.warning.defaultIcon, Icons.warning_amber_outlined);
    });

    test('error has error icon', () {
      expect(BannerType.error.defaultIcon, Icons.error_outline);
    });
  });

  group('BannerStyle', () {
    testWidgets('resolveColor returns primary for info', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: ColorScheme.light(primary: Colors.blue)),
          home: Builder(
            builder: (context) {
              final color = BannerStyle.resolveColor(context, BannerType.info);
              expect(color, Colors.blue);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('resolveColor returns primary for success', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: ColorScheme.light(primary: Colors.green)),
          home: Builder(
            builder: (context) {
              final color = BannerStyle.resolveColor(context, BannerType.success);
              expect(color, Colors.green);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('resolveColor returns tertiary for warning', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: ColorScheme.light(tertiary: Colors.orange)),
          home: Builder(
            builder: (context) {
              final color = BannerStyle.resolveColor(context, BannerType.warning);
              expect(color, Colors.orange);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('resolveColor returns error for error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: ColorScheme.light(error: Colors.red)),
          home: Builder(
            builder: (context) {
              final color = BannerStyle.resolveColor(context, BannerType.error);
              expect(color, Colors.red);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('buildDecoration creates BoxDecoration', () {
      final decoration = BannerStyle.buildDecoration(
        backgroundColor: Colors.blue,
        radius: 12.0,
      );
      expect(decoration.borderRadius, BorderRadius.circular(12));
      expect(decoration.boxShadow, isNotEmpty);
    });
  });

  group('AnimationUtils', () {
    test('transition duration is 300ms', () {
      expect(AnimationUtils.transitionDuration, const Duration(milliseconds: 300));
    });

    test('swipe dismiss threshold is 100px', () {
      expect(AnimationUtils.swipeDismissThreshold, 100.0);
    });

    test('default curve is easeOutCubic', () {
      expect(AnimationUtils.defaultCurve, Curves.easeOutCubic);
    });
  });
}
