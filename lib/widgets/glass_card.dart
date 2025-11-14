import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final LinearGradient? gradient;

  // New parameters for enhanced functionality
  final Color? borderGlowColor;
  final bool animateBlur;
  final double maxBlur;
  final bool useThemeDecoration;
  final bool enableShadows;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.2,
    this.borderRadius,
    this.padding,
    this.margin,
    this.gradient,
    this.borderGlowColor,
    this.animateBlur = false,
    this.maxBlur = 15,
    this.useThemeDecoration = false,
    this.enableShadows = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for border glow
    _glowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    // Create tween animation for pulsing border glow (0.2 to 0.8 opacity)
    _glowAnimation = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    // Start repeating animation if border glow is enabled
    if (widget.borderGlowColor != null) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GlassCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle animation state changes
    if (widget.borderGlowColor != null && oldWidget.borderGlowColor == null) {
      _glowController.repeat(reverse: true);
    } else if (widget.borderGlowColor == null && oldWidget.borderGlowColor != null) {
      _glowController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(20);

    // Use theme decoration if enabled
    if (widget.useThemeDecoration) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: widget.margin,
        decoration: AppTheme.getGlassDecoration(isDark: isDarkMode),
        child: ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: _buildBlurContent(isDarkMode, effectiveBorderRadius),
        ),
      );
    }

    // Custom decoration with animated border glow
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: widget.borderGlowColor != null
                ? widget.borderGlowColor!.withOpacity(_glowAnimation.value)
                : AppTheme.glassBorder,
              width: 1.5,
            ),
            boxShadow: widget.enableShadows ? _buildShadows(isDarkMode) : null,
          ),
          child: ClipRRect(
            borderRadius: effectiveBorderRadius,
            child: _buildBlurContent(isDarkMode, effectiveBorderRadius),
          ),
        );
      },
    );
  }

  Widget _buildBlurContent(bool isDarkMode, BorderRadius effectiveBorderRadius) {
    final blurWidget = widget.animateBlur
      ? TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: widget.blur.clamp(0.0, widget.maxBlur)),
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, blurValue, child) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
              child: child!,
            );
          },
          child: _buildInnerContainer(isDarkMode),
        )
      : BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blur.clamp(0.0, widget.maxBlur),
            sigmaY: widget.blur.clamp(0.0, widget.maxBlur),
          ),
          child: _buildInnerContainer(isDarkMode),
        );

    return RepaintBoundary(child: blurWidget);
  }

  Widget _buildInnerContainer(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.gradient ?? LinearGradient(
          colors: isDarkMode
            ? [
                AppTheme.glassDark.withOpacity(widget.opacity),
                AppTheme.glassDark.withOpacity(widget.opacity * 0.5),
              ]
            : [
                AppTheme.glassWhite.withOpacity(widget.opacity * 5), // Multiply by 5 since glassWhite is already at 0.1 opacity
                AppTheme.glassWhite.withOpacity(widget.opacity * 2.5),
              ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: widget.padding ?? EdgeInsets.all(20),
      child: widget.child,
    );
  }

  List<BoxShadow> _buildShadows(bool isDarkMode) {
    final List<BoxShadow> shadows = [];

    // Outer glow shadow
    if (widget.borderGlowColor != null) {
      shadows.add(
        BoxShadow(
          color: widget.borderGlowColor!.withOpacity(_glowAnimation.value * 0.5),
          blurRadius: 20,
          spreadRadius: _glowAnimation.value * 2,
          offset: Offset(0, 0),
        ),
      );
    } else {
      shadows.add(
        BoxShadow(
          color: isDarkMode ? AppTheme.glowBlue : AppTheme.glowPurple,
          blurRadius: 20,
          offset: Offset(0, 4),
        ),
      );
    }

    // Inner highlight shadow
    shadows.add(
      BoxShadow(
        color: AppTheme.glassHighlight,
        blurRadius: 10,
        offset: Offset(0, -2),
      ),
    );

    return shadows;
  }
}
