import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _pulseController;
  double _direction = 0;
  bool _isCalibrating = true;

  @override
  void initState() {
    super.initState();
    _compassController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Simulate calibration
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isCalibrating = false);
        _startCompass();
      }
    });
  }

  void _startCompass() {
    // Simulate compass movement (Kıble direction for Istanbul is approx 150°)
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _direction = 150);
      }
    });
  }

  @override
  void dispose() {
    _compassController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: [
          AppTheme.qiblaGradientStart,
          AppTheme.qiblaGradientEnd,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        child: SafeArea(
          child: _isCalibrating
              ? _buildCalibrating()
              : CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    _buildHeader(),
                    _buildCompass(),
                    _buildInfo(),
                    SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCalibrating() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Pulse(
            infinite: true,
            child: Icon(
              Icons.explore,
              size: 100,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Pusula kalibre ediliyor...',
            style: AppTheme.heading2.copyWith(color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Lütfen telefonunuzu düz tutun',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: FadeInDown(
        duration: Duration(milliseconds: 800),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Kıble Yönü',
                style: AppTheme.heading1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'İstanbul, Türkiye',
                style: AppTheme.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: Duration(milliseconds: 800),
        child: Container(
          margin: EdgeInsets.all(20),
          child: GlassCard(
            blur: 20,
            opacity: 0.2,
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1 + (_pulseController.value * 0.05),
                      child: Transform.rotate(
                        angle: -_direction * math.pi / 180,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Compass circle
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                              ),
                              // North indicator
                              Positioned(
                                top: 20,
                                child: Text(
                                  'N',
                                  style: AppTheme.heading2.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Kıble direction arrow
                              Transform.rotate(
                                angle: _direction * math.pi / 180,
                                child: Icon(
                                  Icons.navigation,
                                  size: 80,
                                  color: AppTheme.secondaryGold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),
                Text(
                  '${_direction.toStringAsFixed(1)}°',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Kıble Açısı',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: Duration(milliseconds: 1000),
        delay: Duration(milliseconds: 200),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: GlassCard(
            blur: 15,
            opacity: 0.2,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppTheme.secondaryGold, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mesafe',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '2,081 km',
                            style: AppTheme.heading3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.white.withOpacity(0.2), height: 32),
                Row(
                  children: [
                    Icon(Icons.mosque, color: AppTheme.secondaryGold, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hedef',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            'Kabe, Mekke',
                            style: AppTheme.heading3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
