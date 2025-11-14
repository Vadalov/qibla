import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShadcnAnimatedLogo extends StatefulWidget {
  final double size;
  final Color color;
  
  const ShadcnAnimatedLogo({
    Key? key,
    this.size = 120,
    this.color = const Color(0xFF0EA5E9),
  }) : super(key: key);

  @override
  State<ShadcnAnimatedLogo> createState() => _ShadcnAnimatedLogoState();
}

class _ShadcnAnimatedLogoState extends State<ShadcnAnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 3.14159 / 180,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.8),
                      widget.color.withValues(alpha: 0.4),
                      widget.color.withValues(alpha: 0.1),
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomPaint(
                    size: Size(widget.size * 0.6, widget.size * 0.6),
                    painter: ShadcnLogoPainter(color: widget.color),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShadcnLogoPainter extends CustomPainter {
  final Color color;

  ShadcnLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Modern Shadcn-inspired geometric design
    final path = Path();
    
    // Outer hexagon
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * 3.14159 / 180;
      final x = center.dx + radius * 0.8 * math.cos(angle);
      final y = center.dy + radius * 0.8 * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Inner geometric pattern
    paint.color = color.withValues(alpha: 0.7);
    final innerPath = Path();
    
    for (int i = 0; i < 3; i++) {
      final angle = (i * 120 + 30) * 3.14159 / 180;
      final x = center.dx + radius * 0.4 * math.cos(angle);
      final y = center.dy + radius * 0.4 * math.sin(angle);
      
      if (i == 0) {
        innerPath.moveTo(x, y);
      } else {
        innerPath.lineTo(x, y);
      }
    }
    innerPath.close();
    
    canvas.drawPath(innerPath, paint);
    
    // Center dot
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MooshenWaveAnimation extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  
  const MooshenWaveAnimation({
    Key? key,
    this.width = 200,
    this.height = 100,
    this.color = const Color(0xFF8B5CF6),
  }) : super(key: key);

  @override
  State<MooshenWaveAnimation> createState() => _MooshenWaveAnimationState();
}

class _MooshenWaveAnimationState extends State<MooshenWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: MooshenWavePainter(
            animationValue: _waveAnimation.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class MooshenWavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  MooshenWavePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final path = Path();
    
    // Create wave pattern
    path.moveTo(0, size.height / 2);
    
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + 
          20 * math.sin((x / size.width * 4 * 3.14159) + animationValue) +
          10 * math.sin((x / size.width * 8 * 3.14159) + animationValue * 1.5);
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Second wave layer
    paint.color = color.withValues(alpha: 0.4);
    final path2 = Path();
    
    path2.moveTo(0, size.height / 2 + 20);
    
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + 20 + 
          15 * math.sin((x / size.width * 3 * 3.14159) + animationValue * 0.8);
      path2.lineTo(x, y);
    }
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShadcnPulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scaleFactor;
  
  const ShadcnPulseAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.scaleFactor = 0.05,
  }) : super(key: key);

  @override
  State<ShadcnPulseAnimation> createState() => _ShadcnPulseAnimationState();
}

class _ShadcnPulseAnimationState extends State<ShadcnPulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0 - widget.scaleFactor,
      end: 1.0 + widget.scaleFactor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class ShadcnFloatingAnimation extends StatefulWidget {
  final Widget child;
  final double floatHeight;
  final Duration duration;
  
  const ShadcnFloatingAnimation({
    Key? key,
    required this.child,
    this.floatHeight = 10.0,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<ShadcnFloatingAnimation> createState() => _ShadcnFloatingAnimationState();
}

class _ShadcnFloatingAnimationState extends State<ShadcnFloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: 0,
      end: widget.floatHeight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_floatAnimation.value),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}