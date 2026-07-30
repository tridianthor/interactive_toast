import 'dart:async';
import 'package:flutter/material.dart';
import 'banner_type.dart';
import 'banner_action.dart';
import 'utils/banner_style.dart';
import 'utils/animation_utils.dart';

/// Configuration for banner display
class BannerConfig {
  final String message;
  final BannerType type;
  final IconData? icon;
  final Duration duration;
  final bool showProgress;
  final BannerAction? action;
  final Curve curve;

  const BannerConfig({
    required this.message,
    this.type = BannerType.info,
    this.icon,
    this.duration = const Duration(seconds: 3),
    this.showProgress = false,
    this.action,
    this.curve = Curves.easeOutCubic,
  });
}

/// Entry point for creating and managing overlay banner
class AppBannerEntry {
  OverlayEntry? _overlayEntry;
  AnimationController? _animationController;
  Timer? _timer;
  Duration? _remainingDuration;
  final BannerConfig? _config;
  VoidCallback? _onDismiss;

  AppBannerEntry({BannerConfig? config}) : _config = config;

  void show(BuildContext context) {
    _buildOverlayEntry(context);
  }

  void dismiss() {
    _timer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController?.dispose();
    _animationController = null;
  }

  void _buildOverlayEntry(BuildContext context) {
    final config = _config;
    if (config == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _BannerOverlayWidget(
        config: config,
        onDismiss: () {
          _onDismiss?.call();
          dismiss();
        },
        onTimerPause: _pauseTimer,
        onTimerResume: _resumeTimer,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resumeTimer() {
    if (_remainingDuration != null && _remainingDuration!.inMilliseconds > 0) {
      _timer = Timer(_remainingDuration!, _handleAutoDismiss);
    }
  }

  void _handleAutoDismiss() {
    _onDismiss?.call();
    dismiss();
  }
}

class _BannerOverlayWidget extends StatefulWidget {
  final BannerConfig config;
  final VoidCallback onDismiss;
  final VoidCallback onTimerPause;
  final VoidCallback onTimerResume;

  const _BannerOverlayWidget({
    required this.config,
    required this.onDismiss,
    required this.onTimerPause,
    required this.onTimerResume,
  });

  @override
  State<_BannerOverlayWidget> createState() => _BannerOverlayWidgetState();
}

class _BannerOverlayWidgetState extends State<_BannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  Timer? _timer;
  double _dragOffset = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AnimationUtils.transitionDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AnimationUtils.defaultCurve,
    ));
    _animationController.forward();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(widget.config.duration, widget.onDismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    const bannerHeight = 72.0;

    return Positioned(
      top: topPadding,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
            onVerticalDragStart: _onDragStart,
            onVerticalDragUpdate: _onDragUpdate,
            onVerticalDragEnd: _onDragEnd,
            child: _buildBanner(context, bannerHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context, double bannerHeight) {
    final colorScheme = Theme.of(context).colorScheme;
    final bannerColor = BannerStyle.resolveColor(context, widget.config.type);

    return Transform.translate(
      offset: Offset(0, _dragOffset),
      child: Opacity(
        opacity: _isDragging ? (1.0 - (_dragOffset.abs() / 200)).clamp(0.0, 1.0) : 1.0,
        child: Transform.scale(
          scale: _isDragging ? (1.0 - (_dragOffset.abs() / 2000)).clamp(0.95, 1.0) : 1.0,
          child: Container(
            height: bannerHeight,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BannerStyle.buildDecoration(
              backgroundColor: colorScheme.surface,
              radius: BannerStyle.borderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          widget.config.icon ?? widget.config.type.defaultIcon,
                          color: bannerColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.config.message,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.config.action != null)
                          TextButton(
                            onPressed: widget.config.action!.onTap,
                            child: Text(widget.config.action!.label),
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.config.showProgress)
                  SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(
                        bannerColor.withAlpha(179),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
    _timer?.cancel();
    widget.onTimerPause();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldDismiss = _dragOffset > AnimationUtils.swipeDismissThreshold || velocity > AnimationUtils.swipeVelocityThreshold;

    if (shouldDismiss) {
      widget.onDismiss();
    } else {
      setState(() {
        _isDragging = false;
        _dragOffset = 0;
      });
      _startTimer();
    }
  }
}
