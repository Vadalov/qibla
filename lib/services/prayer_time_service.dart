import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class PrayerTimeService {
  static const String _baseUrl = 'http://api.aladhan.com/v1';
  final StorageService _storage = StorageService();

  /// Fetch prayer times for a specific location and date
  /// Uses Aladhan API (https://aladhan.com/)
  Future<PrayerTimes?> getPrayerTimes({
    required double latitude,
    required double longitude,
    String? locationName,
    int? day,
    int? month,
    int? year,
  }) async {
    try {
      // Use current date if not specified
      final now = DateTime.now();
      final targetDay = day ?? now.day;
      final targetMonth = month ?? now.month;
      final targetYear = year ?? now.year;

      // Build the API URL
      final url =
          '$_baseUrl/timings/$targetDay-$targetMonth-$targetYear?latitude=$latitude&longitude=$longitude&method=2';

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Prayer time API request timed out'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final timings = data['data']['timings'] as Map<String, dynamic>;
        
        // Extract Hijri date
        final hijriData = data['data']['date']['hijri'] as Map<String, dynamic>?;
        final hijriDay = hijriData?['day'] as String? ?? '1';
        final hijriMonth = hijriData?['month']['en'] as String? ?? 'Muharram';
        final hijriYear = hijriData?['year'] as String? ?? '1445';

        final prayerTimes = PrayerTimes(
          fajr: _formatTime(timings['Fajr'] ?? '05:00'),
          sunrise: _formatTime(timings['Sunrise'] ?? '07:00'),
          dhuhr: _formatTime(timings['Dhuhr'] ?? '12:00'),
          asr: _formatTime(timings['Asr'] ?? '15:00'),
          maghrib: _formatTime(timings['Maghrib'] ?? '18:00'),
          isha: _formatTime(timings['Isha'] ?? '20:00'),
          suhoor: _formatTime(timings['Imsak'] ?? '04:30'),
          iftaar: _formatTime(timings['Maghrib'] ?? '18:00'),
          sunset: _formatTime(timings['Sunset'] ?? '18:00'),
          midday: _formatTime(timings['Midday'] ?? '12:00'),
          location: locationName ?? 'Unknown',
          date: DateTime(targetYear, targetMonth, targetDay),
          hijriDay: hijriDay,
          hijriMonth: hijriMonth,
          hijriYear: hijriYear,
        );

        // Save to storage
        await _savePrayerTimes(prayerTimes);

        return prayerTimes;
      } else {
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout: $e');
      // Return cached times if available
      return _getCachedPrayerTimes();
    } catch (e) {
      debugPrint('Error fetching prayer times: $e');
      // Return cached times if available
      return _getCachedPrayerTimes();
    }
  }

  /// Get next prayer information
  Future<NextPrayer> getNextPrayer({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    final times = await getPrayerTimes(
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
    );

    if (times == null) {
      return NextPrayer(
        name: 'Bilinmiyor',
        time: '-- : --',
        remainingMinutes: 0,
      );
    }

    final now = DateTime.now();
    final prayers = [
      ('Sabah (Fajr)', times.fajr),
      ('Öğlen (Dhuhr)', times.dhuhr),
      ('İkindi (Asr)', times.asr),
      ('Akşam (Maghrib)', times.maghrib),
      ('Yatsı (Isha)', times.isha),
    ];

    for (final prayer in prayers) {
      final prayerTime = _parseTime(prayer.$2);
      if (prayerTime.isAfter(now)) {
        final remaining = prayerTime.difference(now).inMinutes;
        return NextPrayer(
          name: prayer.$1,
          time: prayer.$2,
          remainingMinutes: remaining,
        );
      }
    }

    // If no prayer found today, return Fajr of tomorrow
    return NextPrayer(
      name: 'Sabah (Fajr)',
      time: times.fajr,
      remainingMinutes: 0,
    );
  }

  /// Get monthly prayer times
  Future<Map<int, PrayerTimes>> getMonthlyPrayerTimes({
    required double latitude,
    required double longitude,
    String? locationName,
    int? month,
    int? year,
  }) async {
    final monthlyTimes = <int, PrayerTimes>{};
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    // Get the last day of the month
    final lastDay = DateTime(targetYear, targetMonth + 1, 0).day;

    try {
      for (int day = 1; day <= lastDay; day++) {
        final times = await getPrayerTimes(
          latitude: latitude,
          longitude: longitude,
          locationName: locationName,
          day: day,
          month: targetMonth,
          year: targetYear,
        );

        if (times != null) {
          monthlyTimes[day] = times;
        }
      }
    } catch (e) {
      debugPrint('Error fetching monthly prayer times: $e');
    }

    return monthlyTimes;
  }

  /// Save prayer times to storage
  Future<void> _savePrayerTimes(PrayerTimes times) async {
    await _storage.init();
    await _storage.setPrayerTimes(
      times.fajr,
      times.dhuhr,
      times.asr,
      times.maghrib,
      times.isha,
    );
    await _storage.setLocationName(times.location);
  }

  /// Get cached prayer times from storage
  PrayerTimes? _getCachedPrayerTimes() {
    try {
      final times = _storage.getPrayerTimes();
      final location = _storage.getLocationName();

      return PrayerTimes(
        fajr: times['fajr'] ?? '05:30',
        sunrise: '07:00',
        dhuhr: times['dhuhr'] ?? '12:15',
        asr: times['asr'] ?? '15:45',
        maghrib: times['maghrib'] ?? '17:30',
        isha: times['isha'] ?? '19:00',
        suhoor: times['suhoor'] ?? '04:15',
        iftaar: times['maghrib'] ?? '17:30',
        sunset: '17:30',
        midday: '12:00',
        location: location,
        date: DateTime.now(),
        hijriDay: '1',
        hijriMonth: 'Muharram',
        hijriYear: '1445',
      );
    } catch (e) {
      return null;
    }
  }

  /// Format time string (HH:MM format)
  String _formatTime(String time) {
    if (time.contains(':')) {
      return time.split(':').take(2).join(':');
    }
    return '00:00';
  }

  /// Parse time string to DateTime
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
}

class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String suhoor; // Imsak - Sahur vakti
  final String iftaar; // Maghrib - İftar vakti (Maghrib ile aynı)
  final String sunset; // Güneş batışı
  final String midday; // Gün ortası
  final String location;
  final DateTime date;
  final String hijriDay;
  final String hijriMonth;
  final String hijriYear;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.suhoor,
    required this.iftaar,
    required this.sunset,
    required this.midday,
    required this.location,
    required this.date,
    this.hijriDay = '1',
    this.hijriMonth = 'Muharram',
    this.hijriYear = '1445',
  });
}

class NextPrayer {
  final String name;
  final String time;
  final int remainingMinutes;

  NextPrayer({
    required this.name,
    required this.time,
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

class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);

  @override
  String toString() => message;
}
