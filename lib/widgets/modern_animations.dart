import 'package:flutter/material.dart';
import 'dart:math' as math;

class ModernParticleAnimation extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final int particleCount;
  
  const ModernParticleAnimation({
    Key? key,
    this.width = 300,
    this.height = 200,
    this.color = const Color(0xFF06B6D4),
    this.particleCount = 50,
  }) : super(key: key);

  @override
  State<ModernParticleAnimation> createState() => _ModernParticleAnimationState();
}

class _ModernParticleAnimationState extends State<ModernParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: math.Random().nextDouble() * widget.width,
        y: math.Random().nextDouble() * widget.height,
        vx: (math.Random().nextDouble() - 0.5) * 2,
        vy: (math.Random().nextDouble() - 0.5) * 2,
        size: math.Random().nextDouble() * 4 + 1,
        opacity: math.Random().nextDouble() * 0.5 + 0.5,
      );
    });
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
          painter: ParticlePainter(
            particles: _particles,
            color: widget.color,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class Particle {
  double x, y, vx, vy, size, opacity;
  
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
  });

  void update(double width, double height) {
    x += vx;
    y += vy;
    
    if (x < 0 || x > width) vx = -vx;
    if (y < 0 || y > height) vy = -vy;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    
    for (final particle in particles) {
      particle.update(size.width, size.height);
      
      paint.color = color.withValues(alpha: particle.opacity * (0.5 + 0.5 * math.sin(animationValue * 2 * math.pi)));
      
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NeonGlowAnimation extends StatefulWidget {
  final double size;
  final Color color;
  final Widget? child;
  
  const NeonGlowAnimation({
    Key? key,
    this.size = 100,
    this.color = const Color(0xFF00FF88),
    this.child,
  }) : super(key: key);

  @override
  State<NeonGlowAnimation> createState() => _NeonGlowAnimationState();
}

class _NeonGlowAnimationState extends State<NeonGlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
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
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.color.withValues(alpha: _glowAnimation.value),
                widget.color.withValues(alpha: _glowAnimation.value * 0.5),
                Colors.transparent,
              ],
              stops: const [0.3, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _glowAnimation.value * 0.8),
                blurRadius: 30 * _glowAnimation.value,
                spreadRadius: 10 * _glowAnimation.value,
              ),
            ],
          ),
          child: Center(
            child: widget.child ?? const Icon(
              Icons.circle,
              color: Colors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}

class MorphingShapeAnimation extends StatefulWidget {
  final double size;
  final Color color;
  
  const MorphingShapeAnimation({
    Key? key,
    this.size = 150,
    this.color = const Color(0xFF8B5CF6),
  }) : super(key: key);

  @override
  State<MorphingShapeAnimation> createState() => _MorphingShapeAnimationState();
}

class _MorphingShapeAnimationState extends State<MorphingShapeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _morphAnimation = Tween<double>(begin: 0, end: 1).animate(
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
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: MorphingShapePainter(
            animationValue: _morphAnimation.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class MorphingShapePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  MorphingShapePainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Morph between circle and hexagon
    final path = Path();
    
    if (animationValue < 0.5) {
      // Circle phase
      final circleRadius = radius * (1 - animationValue * 0.3);
      path.addOval(Rect.fromCircle(center: center, radius: circleRadius));
    } else {
      // Hexagon phase
      final morphProgress = (animationValue - 0.5) * 2;
      final hexRadius = radius * (0.7 + morphProgress * 0.3);
      
      for (int i = 0; i < 6; i++) {
        final angle = (i * 60) * math.pi / 180;
        final x = center.dx + hexRadius * math.cos(angle);
        final y = center.dy + hexRadius * math.sin(angle);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
    }

    canvas.drawPath(path, paint);

    // Inner animated element
    paint.color = color.withValues(alpha: 0.9);
    final innerSize = radius * 0.4 * (0.5 + 0.5 * math.sin(animationValue * 2 * math.pi));
    
    if (animationValue < 0.5) {
      canvas.drawCircle(center, innerSize, paint);
    } else {
      final trianglePath = Path();
      final triangleSize = innerSize * 1.5;
      
      for (int i = 0; i < 3; i++) {
        final angle = (i * 120 - 90) * math.pi / 180;
        final x = center.dx + triangleSize * math.cos(angle);
        final y = center.dy + triangleSize * math.sin(angle);
        
        if (i == 0) {
          trianglePath.moveTo(x, y);
        } else {
          trianglePath.lineTo(x, y);
        }
      }
      trianglePath.close();
      
      canvas.drawPath(trianglePath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ShimmerLoadingAnimation extends StatefulWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;
  
  const ShimmerLoadingAnimation({
    Key? key,
    this.width = 200,
    this.height = 20,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  }) : super(key: key);

  @override
  State<ShimmerLoadingAnimation> createState() => _ShimmerLoadingAnimationState();
}

class _ShimmerLoadingAnimationState extends State<ShimmerLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
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
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment(_shimmerAnimation.value, 0),
              end: Alignment(_shimmerAnimation.value + 1, 0),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}