import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class QiblaCompassPage extends StatelessWidget {
  const QiblaCompassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E1E), Color(0xFF0E1530)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: const [
                    Icon(Icons.explore, color: AppTheme.secondaryGold),
                    SizedBox(width: 10),
                    Text(
                      'Kıble Pusulası',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: math.pi / 3),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value,
                        child: child,
                      );
                    },
                    child: _CompassBody(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  children: [
                    _GlassTextChip(
                      icon: Icons.place,
                      label: 'Kıbleye Yönünüz • 151°',
                      trailing: '2980 km',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Telefonunuzu düz tutun ve pusulayı hizalayın.',
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompassBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 320,
          width: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFF1B2344), Color(0xFF0C1328)],
              radius: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 40,
                offset: const Offset(0, 24),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _CompassPainter(),
          ),
        ),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppTheme.secondaryGold, AppTheme.qiblaGradientStart],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondaryGold.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.explore,
            color: Colors.white,
            size: 48,
          ),
        ),
        Positioned(
          top: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.star, color: AppTheme.neonCyan, size: 18),
                SizedBox(width: 8),
                Text(
                  'Kıble • 151°',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ringPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0x33FFFFFF),
          Color(0x55FFFFFF),
          Color(0x33FFFFFF),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius - 6, ringPaint);

    final markerPaint = Paint()
      ..color = AppTheme.secondaryGold
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final angle = -math.pi / 3;
    final start = Offset(
      center.dx + (radius - 40) * math.cos(angle),
      center.dy + (radius - 40) * math.sin(angle),
    );
    final end = Offset(
      center.dx + (radius - 70) * math.cos(angle),
      center.dy + (radius - 70) * math.sin(angle),
    );
    canvas.drawLine(start, end, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlassTextChip extends StatelessWidget {
  const _GlassTextChip({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  final IconData icon;
  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                trailing,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
