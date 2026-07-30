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
  GlobalKey<_BannerOverlayWidgetState>? _stateKey;
  final BannerConfig? _config;
  VoidCallback? _onDismiss;

  AppBannerEntry({BannerConfig? config}) : _config = config;

  void show(BuildContext context) {
    _buildOverlayEntry(context);
  }

  void dismiss() {
    _stateKey?.currentState?.dismissWithAnimation();
  }

  void _buildOverlayEntry(BuildContext context) {
    final config = _config;
    if (config == null) return;

    _stateKey = GlobalKey<_BannerOverlayWidgetState>();

    _overlayEntry = OverlayEntry(
      builder: (context) => _BannerOverlayWidget(
        key: _stateKey,
        config: config,
        onDismiss: () {
          _onDismiss?.call();
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }
}

class _BannerOverlayWidget extends StatefulWidget {
  final BannerConfig config;
  final VoidCallback onDismiss;

  const _BannerOverlayWidget({
    super.key,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<_BannerOverlayWidget> createState() => _BannerOverlayWidgetState();
}

class _BannerOverlayWidgetState extends State<_BannerOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _progressController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;

  Timer? _timer;
  Duration _remainingDuration = Duration.zero;
  double _dragOffset = 0;
  bool _isDragging = false;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _remainingDuration = widget.config.duration;
    _initSlideAnimation();
    _initProgressAnimation();
    _slideController.forward();
    _startTimer();
  }

  void _initSlideAnimation() {
    _slideController = AnimationController(
      duration: AnimationUtils.transitionDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: AnimationUtils.defaultCurve,
    ));
  }

  void _initProgressAnimation() {
    _progressController = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_progressController);
    if (widget.config.showProgress) {
      _progressController.forward();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(_remainingDuration, _handleAutoDismiss);
  }

  void _pauseTimer() {
    _timer?.cancel();
    if (_progressController.isAnimating) {
      _remainingDuration = _progressController.duration! * _progressController.value;
      _progressController.stop();
    }
  }

  void _resumeTimer() {
    if (_remainingDuration > Duration.zero) {
      _progressController.duration = _remainingDuration;
      _progressController.forward(from: 0);
      _timer = Timer(_remainingDuration, _handleAutoDismiss);
    }
  }

  void _handleAutoDismiss() {
    dismissWithAnimation();
  }

  void dismissWithAnimation() {
    if (_isDismissing) return;
    _isDismissing = true;
    _timer?.cancel();
    _slideController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

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
            child: _buildBanner(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    const bannerHeight = 72.0;
    final colorScheme = Theme.of(context).colorScheme;
    final bannerColor = BannerStyle.resolveColor(context, widget.config.type);

    final opacity = _isDragging
        ? (1.0 - (_dragOffset.abs() / 200)).clamp(0.0, 1.0)
        : 1.0;
    final scale = _isDragging
        ? (1.0 - (_dragOffset.abs() / 2000)).clamp(0.95, 1.0)
        : 1.0;

    return Transform.translate(
      offset: Offset(0, _dragOffset),
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
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
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(
                            bannerColor.withAlpha(179),
                          ),
                        );
                      },
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
    _pauseTimer();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      if (_dragOffset < 0) _dragOffset = 0;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldDismiss = _dragOffset > AnimationUtils.swipeDismissThreshold ||
                          velocity > AnimationUtils.swipeVelocityThreshold;

    if (shouldDismiss) {
      dismissWithAnimation();
    } else {
      setState(() {
        _isDragging = false;
        _dragOffset = 0;
      });
      _startTimer();
    }
  }
}
