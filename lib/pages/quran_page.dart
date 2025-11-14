import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import 'quran_reader_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final List<Surah> _surahs = [
    Surah('Al-Fatiha', 'الفاتحة', 1, 7, 'Mekke'),
    Surah('Al-Baqarah', 'البقرة', 2, 286, 'Medine'),
    Surah('Al-Imran', 'آل عمران', 3, 200, 'Medine'),
    Surah('An-Nisa', 'النساء', 4, 176, 'Medine'),
    Surah('Al-Maidah', 'المائدة', 5, 120, 'Medine'),
    Surah('Al-Anam', 'الأنعام', 6, 165, 'Mekke'),
    Surah('Al-Araf', 'الأعراف', 7, 206, 'Mekke'),
    Surah('Al-Anfal', 'الأنفال', 8, 75, 'Medine'),
    Surah('At-Tawbah', 'التوبة', 9, 129, 'Medine'),
    Surah('Yunus', 'يونس', 10, 109, 'Mekke'),
    Surah('Hud', 'هود', 11, 123, 'Mekke'),
    Surah('Yusuf', 'يوسف', 12, 111, 'Mekke'),
    Surah('Ar-Ra\'d', 'الرعد', 13, 43, 'Medine'),
    Surah('Ibrahim', 'إبراهيم', 14, 52, 'Mekke'),
    Surah('Al-Hijr', 'الحجر', 15, 99, 'Mekke'),
    Surah('An-Nahl', 'النحل', 16, 128, 'Mekke'),
    Surah('Al-Isra', 'الإسراء', 17, 111, 'Mekke'),
    Surah('Al-Kahf', 'الكهف', 18, 110, 'Mekke'),
    Surah('Maryam', 'مريم', 19, 98, 'Mekke'),
    Surah('Taha', 'طه', 20, 135, 'Mekke'),
    Surah('Al-Anbiya', 'الأنبياء', 21, 112, 'Mekke'),
    Surah('Al-Hajj', 'الحج', 22, 78, 'Medine'),
    Surah('Al-Mu\'minun', 'المؤمنون', 23, 118, 'Mekke'),
    Surah('An-Nur', 'النور', 24, 64, 'Medine'),
    Surah('Al-Furqan', 'الفرقان', 25, 77, 'Mekke'),
    Surah('Ash-Shuara', 'الشعراء', 26, 227, 'Mekke'),
    Surah('An-Naml', 'النمل', 27, 93, 'Mekke'),
    Surah('Al-Qasas', 'القصص', 28, 88, 'Mekke'),
    Surah('Al-Ankabut', 'العنكبوت', 29, 69, 'Mekke'),
    Surah('Ar-Rum', 'الروم', 30, 60, 'Mekke'),
    Surah('Luqman', 'لقمان', 31, 34, 'Mekke'),
    Surah('As-Sajdah', 'السجدة', 32, 30, 'Mekke'),
    Surah('Al-Ahzab', 'الأحزاب', 33, 73, 'Medine'),
    Surah('Saba', 'سبأ', 34, 54, 'Mekke'),
    Surah('Fatir', 'فاطر', 35, 45, 'Mekke'),
    Surah('Yasin', 'يس', 36, 83, 'Mekke'),
    Surah('As-Saffat', 'الصافات', 37, 182, 'Mekke'),
    Surah('Sad', 'ص', 38, 88, 'Mekke'),
    Surah('Az-Zumar', 'الزمر', 39, 75, 'Mekke'),
    Surah('Ghafir', 'غافر', 40, 85, 'Mekke'),
    Surah('Fussilat', 'فصلت', 41, 54, 'Mekke'),
    Surah('Ash-Shura', 'الشورى', 42, 53, 'Mekke'),
    Surah('Az-Zukhruf', 'الزخرف', 43, 89, 'Mekke'),
    Surah('Ad-Dukhan', 'الدخان', 44, 59, 'Mekke'),
    Surah('Al-Jathiyah', 'الجاثية', 45, 37, 'Mekke'),
    Surah('Al-Ahqaf', 'الأحقاف', 46, 35, 'Mekke'),
    Surah('Muhammad', 'محمد', 47, 38, 'Medine'),
    Surah('Al-Fath', 'الفتح', 48, 29, 'Medine'),
    Surah('Al-Hujurat', 'الحجرات', 49, 18, 'Medine'),
    Surah('Qaf', 'ق', 50, 45, 'Mekke'),
    Surah('Ad-Dhariyat', 'الذاريات', 51, 60, 'Mekke'),
    Surah('At-Tur', 'الطور', 52, 49, 'Mekke'),
    Surah('An-Najm', 'النجم', 53, 62, 'Mekke'),
    Surah('Al-Qamar', 'القمر', 54, 55, 'Mekke'),
    Surah('Ar-Rahman', 'الرحمن', 55, 78, 'Medine'),
    Surah('Al-Waqiah', 'الواقعة', 56, 96, 'Mekke'),
    Surah('Al-Hadid', 'الحديد', 57, 29, 'Medine'),
    Surah('Al-Mujadalah', 'المجادلة', 58, 22, 'Medine'),
    Surah('Al-Hashr', 'الحشر', 59, 24, 'Medine'),
    Surah('Al-Mumtahanah', 'الممتحنة', 60, 13, 'Medine'),
    Surah('As-Saff', 'الصف', 61, 14, 'Medine'),
    Surah('Al-Jumu\'ah', 'الجمعة', 62, 11, 'Medine'),
    Surah('Al-Munafiqun', 'المنافقون', 63, 11, 'Medine'),
    Surah('At-Taghabun', 'التغابن', 64, 18, 'Medine'),
    Surah('At-Talaq', 'الطلاق', 65, 12, 'Medine'),
    Surah('At-Tahrim', 'التحريم', 66, 12, 'Medine'),
    Surah('Al-Mulk', 'الملك', 67, 30, 'Mekke'),
    Surah('Al-Qalam', 'القلم', 68, 52, 'Mekke'),
    Surah('Al-Haqqah', 'الحاقة', 69, 52, 'Mekke'),
    Surah('Al-Maarij', 'المعارج', 70, 44, 'Mekke'),
    Surah('Nuh', 'نوح', 71, 28, 'Mekke'),
    Surah('Al-Jinn', 'الجن', 72, 28, 'Mekke'),
    Surah('Al-Muzzammil', 'المزمل', 73, 20, 'Mekke'),
    Surah('Al-Muddathir', 'المدثر', 74, 56, 'Mekke'),
    Surah('Al-Qiyamah', 'القيامة', 75, 40, 'Mekke'),
    Surah('Al-Insan', 'الإنسان', 76, 31, 'Medine'),
    Surah('Al-Mursalat', 'المرسلات', 77, 50, 'Mekke'),
    Surah('An-Naba', 'النبأ', 78, 40, 'Mekke'),
    Surah('An-Nazi\'at', 'النازعات', 79, 46, 'Mekke'),
    Surah('Abasa', 'عبس', 80, 42, 'Mekke'),
    Surah('At-Takwir', 'التكوير', 81, 29, 'Mekke'),
    Surah('Al-Infitar', 'الانفطار', 82, 19, 'Mekke'),
    Surah('Al-Mutaffifin', 'المطففين', 83, 36, 'Mekke'),
    Surah('Al-Inshiqaq', 'الانشقاق', 84, 25, 'Mekke'),
    Surah('Al-Buruj', 'البروج', 85, 22, 'Mekke'),
    Surah('At-Tariq', 'الطارق', 86, 17, 'Mekke'),
    Surah('Al-A\'la', 'الأعلى', 87, 19, 'Mekke'),
    Surah('Al-Ghashiyah', 'الغاشية', 88, 26, 'Mekke'),
    Surah('Al-Fajr', 'الفجر', 89, 30, 'Mekke'),
    Surah('Al-Balad', 'البلد', 90, 20, 'Mekke'),
    Surah('Ash-Shams', 'الشمس', 91, 15, 'Mekke'),
    Surah('Al-Layl', 'الليل', 92, 21, 'Mekke'),
    Surah('Ad-Dhuha', 'الضحى', 93, 11, 'Mekke'),
    Surah('Ash-Sharh', 'الشرح', 94, 8, 'Mekke'),
    Surah('At-Tin', 'التين', 95, 8, 'Mekke'),
    Surah('Al-Alaq', 'العلق', 96, 19, 'Mekke'),
    Surah('Al-Qadr', 'القدر', 97, 5, 'Mekke'),
    Surah('Al-Bayyinah', 'البينة', 98, 8, 'Medine'),
    Surah('Az-Zilzal', 'الزلزال', 99, 8, 'Medine'),
    Surah('Al-Adiyat', 'العاديات', 100, 11, 'Mekke'),
    Surah('Al-Qari\'ah', 'القارعة', 101, 11, 'Mekke'),
    Surah('At-Takathur', 'التكاثر', 102, 8, 'Mekke'),
    Surah('Al-Asr', 'العصر', 103, 3, 'Mekke'),
    Surah('Al-Humazah', 'الهمزة', 104, 9, 'Mekke'),
    Surah('Al-Fil', 'الفيل', 105, 5, 'Mekke'),
    Surah('Quraysh', 'قريش', 106, 4, 'Mekke'),
    Surah('Al-Ma\'un', 'الماعون', 107, 7, 'Mekke'),
    Surah('Al-Kawthar', 'الكوثر', 108, 3, 'Mekke'),
    Surah('Al-Kafirun', 'الكافرون', 109, 6, 'Mekke'),
    Surah('An-Nasr', 'النصر', 110, 3, 'Medine'),
    Surah('Al-Lahab', 'اللهب', 111, 5, 'Mekke'),
    Surah('Al-Ikhlas', 'الإخلاص', 112, 4, 'Mekke'),
    Surah('Al-Falaq', 'الفلق', 113, 5, 'Mekke'),
    Surah('An-Nas', 'الناس', 114, 6, 'Mekke'),
  ];

  final StorageService _storageService = StorageService();
  final AudioService _audioService = AudioService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLastReadLoading = true;
  int _lastSurahNumber = 2;
  String _lastSurahName = 'Al-Baqarah';
  int _lastAyahNumber = 156;
  String _searchQuery = '';
  List<Surah> _filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    _filteredSurahs = _surahs;
    _searchController.addListener(_onSearchChanged);
    _loadLastRead();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredSurahs = _surahs;
      } else {
        _filteredSurahs = _surahs.where((surah) {
          return surah.name.toLowerCase().contains(_searchQuery) ||
              surah.arabic.contains(_searchQuery) ||
              surah.number.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  Future<void> _loadLastRead() async {
    await _storageService.init();
    final lastSurah = _storageService.getLastReadSurah();
    final lastAyah = _storageService.getLastReadAyah();

    setState(() {
      _lastSurahNumber = lastSurah['number'] as int;
      _lastSurahName = lastSurah['name'] as String;
      _lastAyahNumber = lastAyah;
      _isLastReadLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadLastRead,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildHeader(),
              _buildSearchBar(),
              _buildLastRead(),
              _buildSurahList(),
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
        child: Column(
          children: [
            const Icon(
              Icons.menu_book,
              size: 48,
              color: AppTheme.primaryGreen,
            ),
            const SizedBox(height: 12),
            const Text(
              'Kur\'an-ı Kerim',
              style: _headerTitleStyle,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty 
                  ? '114 Sure'
                  : '${_filteredSurahs.length} Sure Bulundu',
              style: _headerSubtitleStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Sure ara...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGreen),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }

  // Cache gradient and decoration to avoid recreation
  static const _lastReadGradient = LinearGradient(
    colors: [
      AppTheme.quranGradientStart,
      AppTheme.quranGradientEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static final _lastReadShadow = BoxShadow(
    color: AppTheme.quranGradientStart.withValues(alpha: 0.3),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  // Cache text styles
  static const _lastReadTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const _lastReadSurahStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const _lastReadAyahStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFFE5E7EB), // Colors.white.withValues(alpha: 0.9)
  );
  
  static const _surahCardNameStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _surahCardInfoStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _surahCardArabicStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _headerTitleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _headerSubtitleStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );

  Widget _buildLastRead() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: GestureDetector(
          onTap: _isLastReadLoading
              ? null
              : () {
                  final surah = _surahs.firstWhere(
                    (s) => s.number == _lastSurahNumber,
                    orElse: () => _surahs.first,
                  );
                  if (mounted) {
                    _openSurah(surah);
                  }
                },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _lastReadGradient,
                boxShadow: [_lastReadShadow],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.bookmark, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Son Okunan',
                          style: _lastReadTitleStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_isLastReadLoading)
                      const Text(
                        'Yükleniyor...',
                        style: _lastReadAyahStyle,
                      )
                    else ...[
                      Text(
                        _lastSurahName,
                        style: _lastReadSurahStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ayet $_lastAyahNumber',
                        style: _lastReadAyahStyle,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahList() {
    if (_filteredSurahs.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Sonuç bulunamadı',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Farklı bir arama terimi deneyin',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverFixedExtentList(
        itemExtent: 84.0, // 12 (bottom padding) + 72 (card height)
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildSurahCard(_filteredSurahs[index]);
          },
          childCount: _filteredSurahs.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
        ),
      ),
    );
  }

  Widget _buildSurahCard(Surah surah) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          height: 72, // Sabit yükseklik
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () => _openSurah(surah),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${surah.number}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                            surah.name,
                            style: _surahCardNameStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${surah.verses} Ayet • ${surah.revelation}',
                            style: _surahCardInfoStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      surah.arabic,
                      style: _surahCardArabicStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSurah(Surah surah) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuranReaderPage(
          surah: surah,
          audioService: _audioService,
          storageService: _storageService,
        ),
      ),
    );
    // Ekrandan dönünce son okunan bilgiyi güncelle
    await _loadLastRead();
  }
}

class Surah {
  final String name;
  final String arabic;
  final int number;
  final int verses;
  final String revelation;

  Surah(this.name, this.arabic, this.number, this.verses, this.revelation);
}
