import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../services/location_service.dart';
import '../services/prayer_time_service.dart' as pts;
import '../services/notification_service.dart';

class TimesPage extends StatefulWidget {
  const TimesPage({super.key});

  @override
  State<TimesPage> createState() => _TimesPageState();
}

class _TimesPageState extends State<TimesPage> {
  bool _isLoading = true;
  pts.PrayerTimes? _prayerTimes;
  pts.NextPrayer? _nextPrayer;
  String? _errorMessage;
  final _prayerTimeService = pts.PrayerTimeService();
  final _locationService = LocationService();
  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Konumu al (izin varsa gerçek, yoksa İstanbul)
    try {
      final location = await _locationService.getCurrentLocation();

      final times = await _prayerTimeService.getPrayerTimes(
        latitude: location.latitude,
        longitude: location.longitude,
        locationName: location.label,
      );

      final nextPrayer = await _prayerTimeService.getNextPrayer(
        latitude: location.latitude,
        longitude: location.longitude,
        locationName: location.label,
      );

      if (!mounted) return;

      if (times == null) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Vakitler yüklenemedi. Lütfen internet bağlantınızı kontrol edip tekrar deneyin.';
        });
      } else {
        setState(() {
          _prayerTimes = times;
          _nextPrayer = nextPrayer;
          _isLoading = false;
          _errorMessage = null;
        });

        // Bildirimleri arka planda planla (hata olursa sessizce yok say)
        // Detaylı zamanlama altyapısı NotificationService içinde geliştirilebilir.
        // Burada iskelet amaçlı basit bir çağrı yapıyoruz.
        _notificationService.scheduleDailyPrayerNotifications(times);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Vakitler yüklenirken bir hata oluştu. Lütfen tekrar deneyin.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPrayerTimes,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildHeader(),
              if (_isLoading)
                SliverFillRemaining(child: _buildLoadingState())
              else ...[
                _buildNextPrayer(),
                _buildAllPrayers(),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Namaz Vakitleri',
                    style: _headerTitleStyle,
                  ),
                  const SizedBox(height: 8),
                  if (!_isLoading && _prayerTimes != null)
                    Text(
                      _prayerTimes!.location,
                      style: _headerLocationStyle,
                    ),
                ],
              ),
            ),
            if (!_isLoading)
              IconButton(
                onPressed: _loadPrayerTimes,
                icon: Icon(Icons.refresh, color: Colors.grey.shade700, size: 28),
                tooltip: 'Vakitleri Yenile',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            const Text(
              'Vakitler yükleniyor...',
              style: _loadingTextStyle,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: _errorTextStyle,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPrayerTimes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Cache prayer colors to avoid repeated string operations
  static final Map<String, Color> _prayerColorCache = {
    'fajr': AppTheme.fajrColor,
    'sunrise': AppTheme.sunriseColor,
    'dhuhr': AppTheme.dhuhrColor,
    'asr': AppTheme.asrColor,
    'maghrib': AppTheme.maghribColor,
    'isha': AppTheme.ishaColor,
  };

  // Cache text styles to avoid recreation
  static const _nextPrayerLabelStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF64748B), // Colors.grey.shade600
    fontWeight: FontWeight.w500,
  );
  
  static const _nextPrayerNameStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _nextPrayerTimeStyle = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const _nextPrayerRemainingStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _prayerCardTurkishStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _prayerCardEnglishStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _prayerCardTimeStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _headerTitleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _headerLocationStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _loadingTextStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF475569), // Colors.grey.shade700
  );
  
  static const _errorTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF475569), // Colors.grey.shade700
  );

  Color _getPrayerColor(String? prayerName) {
    if (prayerName == null) return AppTheme.primaryGreen;
    return _prayerColorCache[prayerName.toLowerCase()] ?? AppTheme.primaryGreen;
  }

  Widget _buildNextPrayer() {
    final next = _nextPrayer;
    if (next == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    
    final prayerColor = _getPrayerColor(next.name);
    
    // Cache gradient to avoid recreation
    final gradient = LinearGradient(
      colors: [
        prayerColor.withValues(alpha: 0.1),
        prayerColor.withValues(alpha: 0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: gradient,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Sonraki Vakit',
                    style: _nextPrayerLabelStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    next.name,
                    style: _nextPrayerNameStyle,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: prayerColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: prayerColor.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      next.time,
                      style: _nextPrayerTimeStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${next.formattedRemaining} kaldı',
                    style: _nextPrayerRemainingStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllPrayers() {
    final times = _prayerTimes!;

    final prayers = [
      ('Fajr', 'Sabah', times.fajr, Icons.bedtime, AppTheme.fajrColor),
      ('Sunrise', 'Güneş Doğuşu', times.sunrise, Icons.wb_twilight, AppTheme.sunriseColor),
      ('Dhuhr', 'Öğlen', times.dhuhr, Icons.sunny, AppTheme.dhuhrColor),
      ('Asr', 'İkindi', times.asr, Icons.cloud, AppTheme.asrColor),
      ('Maghrib', 'Akşam', times.maghrib, Icons.sunny_snowing, AppTheme.maghribColor),
      ('Isha', 'Yatsı', times.isha, Icons.nights_stay, AppTheme.ishaColor),
    ];

    return SliverFixedExtentList(
      itemExtent: 84.0, // 12 (vertical padding) * 2 + 72 (card height)
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final prayer = prayers[index];
          return _buildPrayerCard(prayer.$1, prayer.$2, prayer.$3, prayer.$4, prayer.$5);
        },
        childCount: prayers.length,
      ),
    );
  }

  Widget _buildPrayerCard(String englishName, String turkishName, String time, IconData icon, Color prayerColor) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: SizedBox(
          height: 72, // Sabit yükseklik
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: prayerColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: prayerColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          turkishName,
                          style: _prayerCardTurkishStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          englishName,
                          style: _prayerCardEnglishStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    time,
                    style: _prayerCardTimeStyle,
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
