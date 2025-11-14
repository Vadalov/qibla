import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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

enum GradientType {
  linear,
  radial,
  sweep,
}

class GradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  // New parameters for advanced functionality
  final bool animateGradient;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool cycleGradients;
  final List<List<Color>>? gradientList;
  final bool useThemeGradient;
  final ThemeGradientType? themeGradientType;
  final GradientType gradientType;
  final Alignment center;
  final double radius;

  const GradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.animateGradient = false,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.animationCurve = Curves.easeInOut,
    this.cycleGradients = false,
    this.gradientList,
    this.useThemeGradient = false,
    this.themeGradientType,
    this.gradientType = GradientType.linear,
    this.center = Alignment.center,
    this.radius = 1.0,
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground> {
  List<Color> _currentColors = [];
  int _currentGradientIndex = 0;
  Timer? _cycleTimer;

  @override
  void initState() {
    super.initState();
    _initializeColors();

    // Start gradient cycling if enabled
    if (widget.cycleGradients && widget.gradientList != null && widget.gradientList!.length > 1) {
      _startCycling();
    }
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(GradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle cycling changes
    if (widget.cycleGradients != oldWidget.cycleGradients) {
      if (widget.cycleGradients) {
        _startCycling();
      } else {
        _stopCycling();
      }
    }

    // Reinitialize colors if theme gradient type changed
    if (widget.useThemeGradient != oldWidget.useThemeGradient ||
        widget.themeGradientType != oldWidget.themeGradientType) {
      _initializeColors();
    }
  }

  void _initializeColors() {
    if (widget.useThemeGradient && widget.themeGradientType != null) {
      final gradient = _getThemeGradient(widget.themeGradientType!);
      setState(() {
        _currentColors = gradient.colors;
      });
    } else {
      setState(() {
        _currentColors = widget.colors;
      });
    }
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

  void _startCycling() {
    _cycleTimer = Timer.periodic(const Duration(milliseconds: 4000), (timer) {
      if (widget.gradientList != null && widget.gradientList!.isNotEmpty) {
        setState(() {
          _currentGradientIndex = (_currentGradientIndex + 1) % widget.gradientList!.length;
          _currentColors = widget.gradientList![_currentGradientIndex];
        });
      }
    });
  }

  void _stopCycling() {
    _cycleTimer?.cancel();
    _cycleTimer = null;
  }

  Gradient _buildGradient(List<Color> colors) {
    switch (widget.gradientType) {
      case GradientType.linear:
        return LinearGradient(
          colors: colors,
          begin: widget.begin,
          end: widget.end,
        );
      case GradientType.radial:
        return RadialGradient(
          colors: colors,
          center: widget.center,
          radius: widget.radius,
        );
      case GradientType.sweep:
        return SweepGradient(
          colors: colors,
          center: widget.center,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animateGradient) {
      return TweenAnimationBuilder<List<Color>>(
        tween: ColorListTween(begin: widget.colors, end: _currentColors),
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        builder: (context, animatedColors, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: _buildGradient(animatedColors),
            ),
            child: RepaintBoundary(child: widget.child),
          );
        },
      );
    }

    // Static gradient (no animation)
    return Container(
      decoration: BoxDecoration(
        gradient: _buildGradient(_currentColors),
      ),
      child: widget.child,
    );
  }
}

/// Custom Tween for animating between color lists
class ColorListTween extends Tween<List<Color>> {
  ColorListTween({List<Color>? begin, List<Color>? end})
      : super(begin: begin, end: end);

  @override
  List<Color> lerp(double t) {
    if (begin == null || end == null) {
      return begin ?? end ?? [];
    }

    final length = begin!.length > end!.length ? begin!.length : end!.length;
    final result = <Color>[];

    for (int i = 0; i < length; i++) {
      final startColor = begin![i % begin!.length];
      final endColor = end![i % end!.length];
      result.add(Color.lerp(startColor, endColor, t) ?? startColor);
    }

    return result;
  }
}
