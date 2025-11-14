import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;
  bool _initialized = false;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  /// Initialize the storage service
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // ============================================================================
  // QURAN READING PROGRESS
  // ============================================================================

  /// Save last read Surah
  Future<bool> setLastReadSurah(int surahNumber, String surahName) async {
    await _prefs.setInt('last_surah_number', surahNumber);
    return await _prefs.setString('last_surah_name', surahName);
  }

  /// Get last read Surah
  Map<String, dynamic> getLastReadSurah() {
    return {
      'number': _prefs.getInt('last_surah_number') ?? 1,
      'name': _prefs.getString('last_surah_name') ?? 'Al-Fatiha',
    };
  }

  /// Save last read Ayah
  Future<bool> setLastReadAyah(int ayahNumber) {
    return _prefs.setInt('last_ayah_number', ayahNumber);
  }

  /// Get last read Ayah
  int getLastReadAyah() {
    return _prefs.getInt('last_ayah_number') ?? 1;
  }

  // ============================================================================
  // DUA/ZIKIR COUNTERS
  // ============================================================================

  /// Save dua counter value
  Future<bool> setDuaCounter(String duaName, int count) {
    return _prefs.setInt('dua_counter_$duaName', count);
  }

  /// Get dua counter value
  int getDuaCounter(String duaName) {
    return _prefs.getInt('dua_counter_$duaName') ?? 0;
  }

  /// Reset dua counter
  Future<bool> resetDuaCounter(String duaName) {
    return _prefs.remove('dua_counter_$duaName');
  }

  /// Get all dua counters
  Map<String, int> getAllDuaCounters() {
    final counters = <String, int>{};
    for (final key in _prefs.getKeys()) {
      if (key.startsWith('dua_counter_')) {
        final duaName = key.replaceFirst('dua_counter_', '');
        counters[duaName] = _prefs.getInt(key) ?? 0;
      }
    }
    return counters;
  }

  // ============================================================================
  // USER LOCATION & PRAYER TIMES
  // ============================================================================

  /// Save user location (latitude, longitude)
  Future<bool> setLocation(double latitude, double longitude) async {
    await _prefs.setDouble('location_latitude', latitude);
    return await _prefs.setDouble('location_longitude', longitude);
  }

  /// Get user location
  Map<String, double> getLocation() {
    return {
      'latitude': _prefs.getDouble('location_latitude') ?? 0.0,
      'longitude': _prefs.getDouble('location_longitude') ?? 0.0,
    };
  }

  /// Save location name
  Future<bool> setLocationName(String name) {
    return _prefs.setString('location_name', name);
  }

  /// Get location name
  String getLocationName() {
    return _prefs.getString('location_name') ?? 'Unknown Location';
  }

  /// Save prayer times for current date
  Future<bool> setPrayerTimes(
      String fajr, String dhuhr, String asr, String maghrib, String isha) async {
    await _prefs.setString('prayer_time_fajr', fajr);
    await _prefs.setString('prayer_time_dhuhr', dhuhr);
    await _prefs.setString('prayer_time_asr', asr);
    await _prefs.setString('prayer_time_maghrib', maghrib);
    return await _prefs.setString('prayer_time_isha', isha);
  }

  /// Get prayer times
  Map<String, String> getPrayerTimes() {
    return {
      'fajr': _prefs.getString('prayer_time_fajr') ?? '05:30',
      'dhuhr': _prefs.getString('prayer_time_dhuhr') ?? '12:15',
      'asr': _prefs.getString('prayer_time_asr') ?? '15:45',
      'maghrib': _prefs.getString('prayer_time_maghrib') ?? '17:30',
      'isha': _prefs.getString('prayer_time_isha') ?? '19:00',
    };
  }

  // ============================================================================
  // PREFERENCES
  // ============================================================================

  /// Enable/disable notifications
  Future<bool> setNotificationsEnabled(bool enabled) {
    return _prefs.setBool('notifications_enabled', enabled);
  }

  /// Check if notifications are enabled
  bool isNotificationsEnabled() {
    return _prefs.getBool('notifications_enabled') ?? true;
  }

  /// Set app theme (light/dark)
  Future<bool> setThemeDark(bool isDark) {
    return _prefs.setBool('theme_dark', isDark);
  }

  /// Get app theme preference
  bool isThemeDark() {
    return _prefs.getBool('theme_dark') ?? false;
  }

  /// Set language preference
  Future<bool> setLanguage(String languageCode) {
    return _prefs.setString('language', languageCode);
  }

  /// Get language preference
  String getLanguage() {
    return _prefs.getString('language') ?? 'tr';
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Clear all data
  Future<bool> clearAll() {
    return _prefs.clear();
  }

  /// Check if storage is initialized
  bool get isInitialized => _initialized;
}
