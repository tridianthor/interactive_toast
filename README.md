# Interactive Toast

A modern top-anchored interactive toast/banner widget for Flutter with swipe-to-dismiss and Material 3 support.

## Features

- **Top-anchored overlay** - Banners appear at the top of the screen, below the status bar
- **Swipe-to-dismiss** - Swipe up to dismiss with smooth animation
- **Pause-on-touch** - Timer pauses when you interact with the banner
- **Progress indicator** - Optional countdown progress bar
- **Action buttons** - Inline actions without dismissing the banner
- **Material 3** - Adapts to light/dark themes automatically
- **4 banner types** - Info, Success, Warning, Error with default icons

## Installation

```yaml
dependencies:
  interactive_toast: ^1.0.0
```

## Quick Start

```dart
import 'package:interactive_toast/interactive_toast.dart';

void main() {
  runApp(
    AppBanner(
      controller: AppBannerController(),
      child: MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

// Show a banner
AppBanner.of(context).show(context, 'Hello, World!');

// With options
AppBanner.of(context).show(
  context,
  'Operation completed!',
  config: BannerConfig(
    type: BannerType.success,
    duration: Duration(seconds: 5),
    showProgress: true,
    action: BannerAction(
      label: 'UNDO',
      onTap: () => print('Undo tapped'),
    ),
  ),
);
```

## Banner Types

| Type | Default Icon | Use Case |
|------|-------------|----------|
| `BannerType.info` | `Icons.info_outline` | General information |
| `BannerType.success` | `Icons.check_circle_outline` | Success messages |
| `BannerType.warning` | `Icons.warning_amber_outlined` | Warnings |
| `BannerType.error` | `Icons.error_outline` | Errors |

## Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `message` | `String` | required | Banner message text |
| `type` | `BannerType` | `info` | Visual style |
| `icon` | `IconData?` | type default | Custom icon |
| `duration` | `Duration` | 3 seconds | Auto-dismiss delay |
| `showProgress` | `bool` | `false` | Show progress bar |
| `action` | `BannerAction?` | `null` | Action button |
| `curve` | `Curve` | `easeOutCubic` | Animation curve |

## Demo

See the `example/` folder for a complete demo app showcasing all features.

```bash
cd example
flutter run
```

## Architecture

- `AppBanner` - InheritedWidget wrapper for controller access
- `AppBannerController` - Singleton for showing/dismissing banners
- `AppBannerEntry` - Manages OverlayEntry lifecycle and animations

## License

MIT
