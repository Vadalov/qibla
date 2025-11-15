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
  CurrentPrayer? _currentPrayer;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();
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
        day: _selectedDate.day,
        month: _selectedDate.month,
        year: _selectedDate.year,
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
        final currentPrayer = _calculateCurrentPrayer(times);
        
        setState(() {
          _prayerTimes = times;
          _nextPrayer = nextPrayer;
          _currentPrayer = currentPrayer;
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
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage != null && _prayerTimes == null
                ? _buildErrorState()
                : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        _buildCurrentAndNextPrayers(),
        _buildSuhoorIftaarCard(),
        Expanded(
          child: _buildAllPrayers(),
        ),
        _buildSunTimesCard(),
      ],
    );
  }
  
  Widget _buildCurrentAndNextPrayers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(child: _buildCurrentPrayerCard()),
          const SizedBox(width: 8),
          Expanded(child: _buildNextPrayerCard()),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: _errorTextStyle,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPrayerTimes,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    _loadPrayerTimes();
  }

  Widget _buildHeader() {
    final gregorianDate = _formatGregorianDate(_selectedDate);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hicri ve Miladi tarih
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _changeDate(-1),
                icon: const Icon(Icons.chevron_left, color: AppTheme.primaryGreen, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_prayerTimes != null) ...[
                      Text(
                        '${_prayerTimes!.hijriDay} ${_prayerTimes!.hijriMonth}, ${_prayerTimes!.hijriYear}',
                        style: _headerHijriStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      gregorianDate,
                      style: _headerGregorianStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _changeDate(1),
                icon: const Icon(Icons.chevron_right, color: AppTheme.primaryGreen, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatGregorianDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
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
  static const _cardLabelStyle = TextStyle(
    fontSize: 10,
    color: Color(0xFF64748B), // Colors.grey.shade600
    fontWeight: FontWeight.w500,
  );
  
  static const _cardPrayerNameStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _cardTimeStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const _cardSubtitleStyle = TextStyle(
    fontSize: 9,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _suhoorIftaarLabelStyle = TextStyle(
    fontSize: 11,
    color: Color(0xFF64748B), // Colors.grey.shade600
    fontWeight: FontWeight.w500,
  );
  
  static const _suhoorIftaarTimeStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _locationTitleStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _sunTimeLabelStyle = TextStyle(
    fontSize: 10,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _sunTimeValueStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _prayerCardTurkishStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _prayerCardTimeStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _headerHijriStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _headerGregorianStyle = TextStyle(
    fontSize: 11,
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

  /// Mevcut namaz vaktini hesapla
  CurrentPrayer? _calculateCurrentPrayer(pts.PrayerTimes times) {
    final now = DateTime.now();
    
    // Prayer times as DateTime objects
    final prayers = [
      ('Fajr', 'Sabah', times.fajr, times.sunrise),
      ('Dhuhr', 'Öğlen', times.dhuhr, times.asr),
      ('Asr', 'İkindi', times.asr, times.maghrib),
      ('Maghrib', 'Akşam', times.maghrib, times.isha),
      ('Isha', 'Yatsı', times.isha, null),
    ];
    
    for (int i = 0; i < prayers.length; i++) {
      final prayer = prayers[i];
      final prayerTime = _parseTime(prayer.$3);
      
      // Get end time (next prayer time or midnight for Isha)
      DateTime endTime;
      if (prayer.$4 != null) {
        endTime = _parseTime(prayer.$4!);
      } else {
        // For Isha, end time is midnight (next day's Fajr)
        endTime = DateTime(now.year, now.month, now.day, 23, 59);
      }
      
      // Check if current time is within this prayer time
      if (now.isAfter(prayerTime) && now.isBefore(endTime)) {
        return CurrentPrayer(
          name: prayer.$2,
          englishName: prayer.$1,
          startTime: prayer.$3,
          endTime: prayer.$4 ?? '23:59',
          remainingMinutes: endTime.difference(now).inMinutes,
        );
      }
    }
    
    // If before Fajr, we're technically still in Isha period
    final fajrTime = _parseTime(times.fajr);
    if (now.isBefore(fajrTime)) {
      return CurrentPrayer(
        name: 'Yatsı',
        englishName: 'Isha',
        startTime: times.isha,
        endTime: times.fajr,
        remainingMinutes: fajrTime.difference(now).inMinutes,
      );
    }
    
    return null;
  }
  
  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  Widget _buildCurrentPrayerCard() {
    final current = _currentPrayer;
    if (current == null) {
      return const SizedBox.shrink();
    }
    
    final prayerColor = _getPrayerColor(current.englishName);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              prayerColor.withValues(alpha: 0.15),
              prayerColor.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Şu anki vakit',
                style: _cardLabelStyle,
              ),
              const SizedBox(height: 6),
              Text(
                current.name,
                style: _cardPrayerNameStyle,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: prayerColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: prayerColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  current.startTime,
                  style: _cardTimeStyle,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Bitiş: ${current.endTime}',
                style: _cardSubtitleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNextPrayerCard() {
    final next = _nextPrayer;
    if (next == null) {
      return const SizedBox.shrink();
    }
    
    final prayerColor = _getPrayerColor(next.name);
    
    // Cemaat saati hesapla (Ezan'dan 10 dakika sonra)
    final jamaatTime = _addMinutesToTime(next.time, 10);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              prayerColor.withValues(alpha: 0.15),
              prayerColor.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sonraki vakit',
                style: _cardLabelStyle,
              ),
              const SizedBox(height: 6),
              Text(
                next.name,
                style: _cardPrayerNameStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: prayerColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: prayerColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  next.time,
                  style: _cardTimeStyle,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ezan: ${next.time}',
                    style: _cardSubtitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Cemaat: $jamaatTime',
                    style: _cardSubtitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _addMinutesToTime(String time, int minutes) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final totalMinutes = hour * 60 + minute + minutes;
      final newHour = (totalMinutes ~/ 60) % 24;
      final newMinute = totalMinutes % 60;
      return '${newHour.toString().padLeft(2, '0')}:${newMinute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time;
    }
  }
  
  Widget _buildSuhoorIftaarCard() {
    final times = _prayerTimes;
    if (times == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: AppTheme.primaryGreen,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sahur',
                            style: _suhoorIftaarLabelStyle,
                          ),
                          Text(
                            times.suhoor,
                            style: _suhoorIftaarTimeStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: AppTheme.primaryGreen,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'İftar',
                            style: _suhoorIftaarLabelStyle,
                          ),
                          Text(
                            times.iftaar,
                            style: _suhoorIftaarTimeStyle,
                          ),
                        ],
                      ),
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

  Widget _buildAllPrayers() {
    final times = _prayerTimes!;

    final prayers = [
      ('Fajr', 'Sabah', times.fajr, Icons.bedtime, AppTheme.fajrColor),
      ('Dhuhr', 'Öğlen', times.dhuhr, Icons.sunny, AppTheme.dhuhrColor),
      ('Asr', 'İkindi', times.asr, Icons.cloud, AppTheme.asrColor),
      ('Maghrib', 'Akşam', times.maghrib, Icons.sunny_snowing, AppTheme.maghribColor),
      ('Isha', 'Yatsı', times.isha, Icons.nights_stay, AppTheme.ishaColor),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Location header
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppTheme.primaryGreen, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      times.location,
                      style: _locationTitleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade300, height: 1),
              const SizedBox(height: 8),
              // Prayer list
              ...prayers.map((prayer) {
                return _buildPrayerCard(prayer.$1, prayer.$2, prayer.$3, prayer.$4, prayer.$5);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerCard(String englishName, String turkishName, String time, IconData icon, Color prayerColor) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: prayerColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                turkishName,
                style: _prayerCardTurkishStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              time,
              style: _prayerCardTimeStyle,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.notifications_outlined,
              color: AppTheme.primaryGreen,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSunTimesCard() {
    final times = _prayerTimes;
    if (times == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSunTimeItem('Güneş Doğuşu', times.sunrise),
              Container(width: 1, height: 30, color: Colors.grey.shade300),
              _buildSunTimeItem('Öğle Vakti', times.midday),
              Container(width: 1, height: 30, color: Colors.grey.shade300),
              _buildSunTimeItem('Güneş Batışı', times.sunset),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSunTimeItem(String label, String time) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: _sunTimeLabelStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: _sunTimeValueStyle,
        ),
      ],
    );
  }
}

/// Current prayer information
class CurrentPrayer {
  final String name;
  final String englishName;
  final String startTime;
  final String endTime;
  final int remainingMinutes;

  CurrentPrayer({
    required this.name,
    required this.englishName,
    required this.startTime,
    required this.endTime,
    required this.remainingMinutes,
  });

  String get formattedRemaining {
    final hours = remainingMinutes ~/ 60;
    final minutes = remainingMinutes % 60;
    if (hours > 0) {
      return '$hours saat $minutes dakika';
    }
    return '$minutes dakika';
  }
}
