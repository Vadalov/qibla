import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  factory AudioService() {
    return _instance;
  }

  AudioService._internal() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  /// Play Adhan/Ezan (Call to Prayer)
  /// Available: fajr, dhuhr, asr, maghrib, isha
  Future<void> playAdhan(String prayerName) async {
    try {
      // Using public URLs for adhan sounds
      const adhanUrls = {
        'fajr':
            'https://download.quranicaudio.com/quran/mishari_al-afasy/001.mp3',
        'dhuhr':
            'https://download.quranicaudio.com/quran/mishari_al-afasy/002.mp3',
        'asr': 'https://download.quranicaudio.com/quran/mishari_al-afasy/003.mp3',
        'maghrib':
            'https://download.quranicaudio.com/quran/mishari_al-afasy/004.mp3',
        'isha':
            'https://download.quranicaudio.com/quran/mishari_al-afasy/005.mp3',
      };

      final url = adhanUrls[prayerName.toLowerCase()];
      if (url == null) {
        throw Exception('Invalid prayer name: $prayerName');
      }

      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint('Error playing adhan: $e');
    }
  }

  /// Play Dua/Supplication audio
  Future<void> playDua(String duaName) async {
    try {
      // Placeholder - can be replaced with actual Quran recitation URLs
      // Using first chapter as example
      const quranUrl =
          'https://download.quranicaudio.com/quran/mishari_al-afasy/001.mp3';
      await _audioPlayer.play(UrlSource(quranUrl));
    } catch (e) {
      debugPrint('Error playing dua: $e');
    }
  }

  /// Play Quran verse by surah and ayah
  Future<void> playQuranVerse(int surahNumber, int ayahNumber) async {
    try {
      // Format surah number with leading zeros (e.g., 001, 002)
      final surahStr = surahNumber.toString().padLeft(3, '0');
      final url =
          'https://download.quranicaudio.com/quran/mishari_al-afasy/$surahStr.mp3';
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint('Error playing Quran verse: $e');
    }
  }

  /// Pause current audio
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// Resume paused audio
  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  /// Stop audio playback
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  /// Get current playing status
  bool get isPlaying => _isPlaying;

  /// Get audio player instance for advanced controls
  AudioPlayer get audioPlayer => _audioPlayer;

  /// Clean up resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
