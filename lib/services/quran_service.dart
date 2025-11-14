import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranService {
  /// Get verses of a surah with Tajweed/Tecvid markings
  /// Uses Al-Quran Cloud API which provides Uthmani script with full diacritics
  Future<List<QuranVerse>?> getSurahVerses(int surahNumber) async {
    try {
      // Al-Quran Cloud API - Uthmani (Tecvidli) metin için
      final verseUrl = 'https://api.alquran.cloud/v1/surah/$surahNumber/editions/quran-uthmani';
      final translationUrl = 'https://api.alquran.cloud/v1/surah/$surahNumber/tr.diyanet';
      
      // Ayet metinlerini al
      final verseResponse = await http.get(Uri.parse(verseUrl)).timeout(
        const Duration(seconds: 15),
      );
      
      // Türkçe meali al
      final transResponse = await http.get(Uri.parse(translationUrl)).timeout(
        const Duration(seconds: 15),
      );

      if (verseResponse.statusCode == 200) {
        final verseData = jsonDecode(verseResponse.body) as Map<String, dynamic>;
        final verseInfo = verseData['data'] as Map<String, dynamic>?;
        final ayahs = verseInfo?['ayahs'] as List?;
        
        if (ayahs == null) return null;

        // Çeviri metinlerini al
        Map<int, String> translations = {};
        if (transResponse.statusCode == 200) {
          final transData = jsonDecode(transResponse.body) as Map<String, dynamic>;
          final transInfo = transData['data'] as Map<String, dynamic>?;
          final transAyahs = transInfo?['ayahs'] as List?;
          
          if (transAyahs != null) {
            for (var ayah in transAyahs) {
              final ayahData = ayah as Map<String, dynamic>;
              final number = ayahData['number'] as int? ?? 0;
              final text = ayahData['text'] as String? ?? '';
              translations[number] = text;
            }
          }
        }

        return ayahs.map((ayah) {
          final ayahData = ayah as Map<String, dynamic>;
          final number = ayahData['numberInSurah'] as int? ?? 0;
          final text = ayahData['text'] as String? ?? '';
          
          return QuranVerse(
            number: number,
            text: text.trim(),
            translation: translations[number],
          );
        }).toList();
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}

class QuranVerse {
  final int number;
  final String text; // Tecvidli Arapça metin
  final String? translation; // Türkçe meal

  QuranVerse({
    required this.number,
    required this.text,
    this.translation,
  });
}

