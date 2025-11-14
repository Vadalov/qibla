import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';

enum IconAnimationType {
  none,
  spin,
  bounce,
  pulse,
}

enum ThemeGradientType {
  ocean,
  sunset,
  cosmic,
  aurora,
  twilight,
  rose,
  electric,
  midnight,
}

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final LinearGradient? gradient;
  final IconData? icon;
  final Color? textColor;

  // New parameters for enhanced functionality
  final bool enableHaptic;
  final bool enableGlow;
  final bool isLoading;
  final bool enabled;
  final bool useThemeGradient;
  final ThemeGradientType? themeGradientType;
  final IconAnimationType iconAnimation;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.icon,
    this.textColor,
    this.enableHaptic = true,
    this.enableGlow = true,
    this.isLoading = false,
    this.enabled = true,
    this.useThemeGradient = false,
    this.themeGradientType,
    this.iconAnimation = IconAnimationType.none,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;

  late AnimationController _rippleController;
  late AnimationController _glowController;
  late AnimationController _iconController;

  late Animation<double> _rippleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _iconRotation;
  late Animation<double> _iconScale;

  Offset _tapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    // Ripple animation controller
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // Glow pulse animation controller
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _glowAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.isLoading) {
      _glowController.repeat(reverse: true);
    }

    // Icon animation controller
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    _iconScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _glowController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle loading state changes
    if (widget.isLoading && !oldWidget.isLoading) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _glowController.stop();
      _glowController.reset();
    }
  }

  LinearGradient _getEffectiveGradient() {
    if (widget.useThemeGradient && widget.themeGradientType != null) {
      return _getThemeGradient(widget.themeGradientType!);
    }

    if (widget.gradient != null) {
      return widget.gradient!;
    }

    // Default gradient based on theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? AppTheme.twilightGlowGradient : AppTheme.oceanDreamGradient;
  }

  LinearGradient _getThemeGradient(ThemeGradientType type) {
    switch (type) {
      case ThemeGradientType.ocean:
        return AppTheme.oceanDreamGradient;
      case ThemeGradientType.sunset:
        return AppTheme.sunsetMagicGradient;
      case ThemeGradientType.cosmic:
        return AppTheme.cosmicFusionGradient;
      case ThemeGradientType.aurora:
        return AppTheme.auroraBorealisGradient;
      case ThemeGradientType.twilight:
        return AppTheme.twilightGlowGradient;
      case ThemeGradientType.rose:
        return AppTheme.roseQuartzGradient;
      case ThemeGradientType.electric:
        return AppTheme.electricSkyGradient;
      case ThemeGradientType.midnight:
        return AppTheme.midnightShimmerGradient;
    }
  }

  void _animatePress() {
    setState(() => _isPressed = true);

    if (widget.enableHaptic) {
      // debugPrint('Haptic: lightImpact');
      HapticFeedback.lightImpact();
    }

    // Trigger icon animation
    if (widget.icon != null) {
      _iconController.forward();
    }
  }

  void _animateRelease() {
    setState(() => _isPressed = false);

    if (widget.enableHaptic) {
      // debugPrint('Haptic: mediumImpact');
      HapticFeedback.mediumImpact();
    }

    // Reset icon animation
    if (widget.icon != null) {
      _iconController.reverse();
    }

    // Trigger ripple animation
    _rippleController.forward(from: 0.0);

    // Execute callback
    if (widget.enabled && !widget.isLoading) {
      widget.onPressed();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.isLoading) return;

    setState(() {
      _tapPosition = details.localPosition;
    });
    _animatePress();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled || widget.isLoading) return;
    _animateRelease();
  }

  void _handleTapCancel() {
    if (!widget.enabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    if (widget.icon != null) {
      _iconController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = _getEffectiveGradient();
    final gradientColors = effectiveGradient.colors;
    final primaryColor = gradientColors.first;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Determine glow color based on gradient type
    final glowColor = isDarkMode ? AppTheme.glowBlue : AppTheme.glowPurple;

    return Semantics(
      button: true,
      label: widget.text,
      enabled: widget.enabled && !widget.isLoading,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedScale(
            scale: !widget.enabled || widget.isLoading
                ? 1.0
                : _isPressed
                    ? 0.95
                    : _isHovered
                        ? 1.02
                        : 1.0,
            duration: Duration(milliseconds: _isPressed ? 100 : 200),
            curve: _isPressed ? Curves.easeIn : Curves.elasticOut,
            child: AnimatedOpacity(
              opacity: widget.enabled ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: AnimatedBuilder(
                  animation: Listenable.merge([_glowAnimation, _rippleAnimation]),
                  builder: (context, child) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 12.0,
                        end: _isPressed ? 20.0 : 12.0,
                      ),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, blurRadius, _) {
                        return TweenAnimationBuilder<Offset>(
                          tween: Tween(
                            begin: const Offset(0, 6),
                            end: _isPressed ? const Offset(0, 10) : const Offset(0, 6),
                          ),
                          duration: const Duration(milliseconds: 200),
                          builder: (context, shadowOffset, _) {
                            return Container(
                              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              decoration: BoxDecoration(
                                gradient: effectiveGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  // Primary shadow
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.3),
                                    blurRadius: blurRadius,
                                    offset: shadowOffset,
                                  ),
                                  // Glow shadow
                                  if (widget.enableGlow)
                                    BoxShadow(
                                      color: glowColor.withValues(alpha: 0.5 * _glowAnimation.value),
                                      blurRadius: 24 * _glowAnimation.value,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 0),
                                    ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Ripple effect
                                  if (_rippleAnimation.value > 0)
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CustomPaint(
                                          painter: RipplePainter(
                                            progress: _rippleAnimation.value,
                                            rippleColor: AppTheme.rippleColor,
                                            center: _tapPosition,
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Button content
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (widget.isLoading)
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              AppTheme.neonCyan,
                                            ),
                                          ),
                                        )
                                      else if (widget.icon != null) ...[
                                        _buildAnimatedIcon(),
                                        const SizedBox(width: 8),
                                      ],
                                      if (!widget.isLoading)
                                        Text(
                                          widget.text,
                                          style: TextStyle(
                                            color: widget.textColor ?? Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    Widget iconWidget = Icon(
      widget.icon,
      color: widget.textColor ?? Colors.white,
      size: 20,
    );

    switch (widget.iconAnimation) {
      case IconAnimationType.spin:
        return AnimatedBuilder(
          animation: _iconRotation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _iconRotation.value * 6.28319, // 2π radians = 360°
              child: child,
            );
          },
          child: iconWidget,
        );

      case IconAnimationType.bounce:
        return AnimatedBuilder(
          animation: _iconScale,
          builder: (context, child) {
            return Transform.scale(
              scale: _iconScale.value,
              child: child,
            );
          },
          child: iconWidget,
        );

      case IconAnimationType.pulse:
        return AnimatedBuilder(
          animation: _iconScale,
          builder: (context, child) {
            return Transform.scale(
              scale: _iconScale.value,
              child: Opacity(
                opacity: 1.0 - (_iconScale.value - 1.0) * 2,
                child: child,
              ),
            );
          },
          child: iconWidget,
        );

      case IconAnimationType.none:
        return iconWidget;
    }
  }
}

/// Custom painter for ripple effect
class RipplePainter extends CustomPainter {
  final double progress;
  final Color rippleColor;
  final Offset center;

  RipplePainter({
    required this.progress,
    required this.rippleColor,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = rippleColor.withValues(alpha: (1.0 - progress) * 0.5)
      ..style = PaintingStyle.fill;

    final maxRadius = size.width > size.height ? size.width : size.height;
    final radius = maxRadius * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.center != center;
  }
}
