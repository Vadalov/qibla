import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'dart:math' as math;
import 'dart:async';

import '../theme/app_theme.dart';
import '../services/location_service.dart';
import '../services/qibla_service.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double _direction = 0; // Used for compass animation (difference angle)
  double _qiblaBearing = 0; // Absolute Qibla bearing from North
  double _distanceKm = 2081;
  String _locationLabel = 'İstanbul, Türkiye';
  bool _hasError = false;
  String? _errorMessage;

  final _locationService = LocationService();

  StreamSubscription<CompassEvent>? _compassSubscription;

  bool _isCalibrating = true;

  @override
  void initState() {
    super.initState();
    _initQibla();
  }

  Future<void> _initQibla() async {
    setState(() {
      _isCalibrating = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final location = await _locationService.getCurrentLocation();
      final bearing = QiblaService.calculateQiblaBearing(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      final distance = QiblaService.calculateDistanceToKaabaKm(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      _qiblaBearing = bearing;
      _distanceKm = distance;
      _locationLabel = location.label;

      _compassSubscription?.cancel();
      _compassSubscription = FlutterCompass.events?.listen((event) {
        final heading = event.heading;
        if (!mounted || heading == null) return;

        // Difference between Qibla bearing and current heading
        final diff = (_qiblaBearing - heading);

        setState(() {
          _direction = diff;
        });
      });

      if (mounted) {
        setState(() {
          _isCalibrating = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isCalibrating = false;
        _errorMessage =
            'Kıble yönü hesaplanırken bir hata oluştu. Lütfen tekrar deneyin.';
      });
    }
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _initQibla,
          child: _isCalibrating
              ? _buildCalibrating()
              : _hasError
                  ? _buildError()
                  : CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        _buildHeader(),
                        _buildCompass(),
                        _buildInfo(),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 72,
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 24),
            Text(
              _errorMessage ??
                  'Kıble yönü hesaplanırken bir hata oluştu. Lütfen tekrar deneyin.',
              textAlign: TextAlign.center,
              style: _errorTitleStyle,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _initQibla,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrating() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          ),
          const SizedBox(height: 32),
          const Text(
            'Pusula kalibre ediliyor...',
            style: _calibratingTitleStyle,
          ),
          const SizedBox(height: 16),
          const Text(
            'Lütfen telefonunuzu düz tutun',
            style: _calibratingSubtitleStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Kıble Yönü',
              style: _headerTitleStyle,
            ),
            const SizedBox(height: 8),
            Text(
              _locationLabel,
              style: _headerLocationStyle,
            ),
          ],
        ),
      ),
    );
  }

  // Cache static decorations to avoid recreation
  static final _compassGradient = RadialGradient(
    colors: [
      AppTheme.qiblaGradientStart.withValues(alpha: 0.15),
      AppTheme.qiblaGradientEnd.withValues(alpha: 0.05),
    ],
  );
  
  static const _arrowGradient = RadialGradient(
    colors: [
      AppTheme.qiblaGradientStart,
      AppTheme.qiblaGradientEnd,
    ],
  );

  // Cache text styles
  static const _headerTitleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _headerLocationStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _compassBearingStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Color(0xFFF59E0B), // AppTheme.qiblaGradientStart
  );
  
  static const _compassLabelStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF64748B), // Colors.grey.shade600
    fontWeight: FontWeight.w500,
  );
  
  static const _infoLabelStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF64748B), // Colors.grey.shade600
    fontWeight: FontWeight.w500,
  );
  
  static const _infoValueStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _calibratingTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _calibratingSubtitleStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _errorTitleStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF475569), // Colors.grey.shade700
  );

  Widget _buildCompass() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundary(
                  child: Transform.rotate(
                    angle: -_direction * math.pi / 180,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _compassGradient,
                        border: Border.all(
                          color: AppTheme.qiblaGradientStart,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.qiblaGradientStart.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
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
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                          ),
                          // North indicator
                          Positioned(
                            top: 20,
                            child: Text(
                              'N',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                          // Kıble direction arrow
                          Transform.rotate(
                            angle: _direction * math.pi / 180,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: _arrowGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.qiblaGradientStart.withValues(alpha: 0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.navigation,
                                size: 56,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.qiblaGradientStart.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_qiblaBearing.toStringAsFixed(1)}°',
                    style: _compassBearingStyle.copyWith(
                      color: AppTheme.qiblaGradientStart,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kıble Açısı',
                  style: _compassLabelStyle,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  AppTheme.qiblaGradientStart.withValues(alpha: 0.05),
                  AppTheme.qiblaGradientEnd.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.qiblaGradientStart.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_on, color: AppTheme.qiblaGradientStart, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mesafe',
                              style: _infoLabelStyle,
                            ),
                            Text(
                              '${_distanceKm.toStringAsFixed(0)} km',
                              style: _infoValueStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey.shade300, height: 32),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.qiblaGradientEnd.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.mosque, color: AppTheme.qiblaGradientEnd, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hedef',
                              style: _infoLabelStyle,
                            ),
                            Text(
                              'Kabe, Mekke',
                              style: _infoValueStyle,
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
      ),
    );
  }
}
