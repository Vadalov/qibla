import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';

class DuaZikirPage extends StatefulWidget {
  const DuaZikirPage({super.key});

  @override
  State<DuaZikirPage> createState() => _DuaZikirPageState();
}

class _DuaZikirPageState extends State<DuaZikirPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, int> _counters = {};
  late StorageService _storageService;
  late AudioService _audioService;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); // Tab değişince header'ı güncelle
      }
    });
    _storageService = StorageService();
    _audioService = AudioService();
    _searchController.addListener(_onSearchChanged);
    _initializeCounters();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Dua> _filterDuas(List<Dua> duas) {
    if (_searchQuery.isEmpty) return duas;
    return duas.where((dua) {
      return dua.name.toLowerCase().contains(_searchQuery) ||
          dua.arabic.contains(_searchQuery) ||
          (dua.meaning?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();
  }

  /// Load saved counters from storage
  void _initializeCounters() async {
    await _storageService.init();
    final savedCounters = _storageService.getAllDuaCounters();
    setState(() {
      _counters.addAll(savedCounters);
    });
  }


  void _incrementCounter(String duaName) async {
    HapticFeedback.lightImpact();
    setState(() {
      _counters[duaName] = (_counters[duaName] ?? 0) + 1;
    });
    // Save to storage
    await _storageService.setDuaCounter(duaName, _counters[duaName] ?? 0);
  }

  void _resetCounter(String duaName) async {
    HapticFeedback.mediumImpact();
    setState(() {
      _counters[duaName] = 0;
    });
    // Remove from storage
    await _storageService.resetDuaCounter(duaName);
  }

  void _playDuaAudio(String duaName) async {
    await _audioService.playDua(duaName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabs(),
            Expanded(
              child: _buildCurrentTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    // Tab değiştiğinde içeriği güncellemek için listener kullanılıyor
    final currentDuas = _filterDuas(_getCurrentTabDuas());
    return _buildDuaList(currentDuas);
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 32,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Dua & Zikir',
                  style: _headerTitleStyle,
                ),
                if (_searchQuery.isNotEmpty)
                  Text(
                    '${_filterDuas(_getCurrentTabDuas()).length} Dua Bulundu',
                    style: _headerSubtitleStyle,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Dua ara...',
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
    );
  }

  List<Dua> _getCurrentTabDuas() {
    switch (_tabController.index) {
      case 0:
        return _morningDuas;
      case 1:
        return _eveningDuas;
      case 2:
        return _generalDuas;
      default:
        return [];
    }
  }

  // Cache static decorations
  static const _tabGradient = LinearGradient(
    colors: [
      AppTheme.primaryGreen,
      AppTheme.gradientEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static final _tabShadow = BoxShadow(
    color: AppTheme.primaryGreen.withValues(alpha: 0.3),
    blurRadius: 15,
    offset: const Offset(0, 6),
  );
  
  static final _tabContainerShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.05),
    blurRadius: 10,
    offset: const Offset(0, 2),
  );

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [_tabContainerShadow],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: _tabGradient,
          boxShadow: [_tabShadow],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Sabah'),
          Tab(text: 'Akşam'),
          Tab(text: 'Genel'),
        ],
      ),
    );
  }

  Widget _buildDuaList(List<Dua> duas) {
    if (duas.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Sonuç bulunamadı',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Farklı bir arama terimi deneyin',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    // Tek ekrana sığacak kadar dua göster (maksimum 5-6 dua)
    final displayDuas = duas.take(6).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: displayDuas.map((dua) => _buildDuaCard(dua)).toList(),
      ),
    );
  }

  // Cache gradient for counter button
  static const _counterButtonGradient = LinearGradient(
    colors: [
      AppTheme.primaryGreen,
      AppTheme.gradientEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const _progressBarGradient = LinearGradient(
    colors: [
      AppTheme.primaryGreen,
      AppTheme.gradientEnd,
    ],
  );

  // Cache text styles
  static const _headerTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _duaCardNameStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _duaCardMeaningStyle = TextStyle(
    fontSize: 11,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );
  
  static const _duaCardArabicStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A), // Colors.grey.shade900
    height: 1.5,
  );
  
  static const _duaCardCountStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Colors.grey.shade900
  );
  
  static const _headerSubtitleStyle = TextStyle(
    fontSize: 11,
    color: Color(0xFF64748B), // Colors.grey.shade600
  );

  Widget _buildDuaCard(Dua dua) {
    final count = _counters[dua.name] ?? 0;
    final progress = dua.targetCount > 0 ? (count / dua.targetCount).clamp(0.0, 1.0) : 0.0;

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dua.name,
                          style: _duaCardNameStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (dua.meaning != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            dua.meaning!,
                            style: _duaCardMeaningStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _playDuaAudio(dua.name),
                    icon: const Icon(
                      Icons.volume_up,
                      color: AppTheme.primaryGreen,
                      size: 20,
                    ),
                    tooltip: 'Ses oynat',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  dua.arabic,
                  style: _duaCardArabicStyle,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (dua.targetCount > 0) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$count / ${dua.targetCount}',
                      style: _duaCardCountStyle,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _resetCounter(dua.name),
                          icon: Icon(Icons.refresh, color: Colors.grey.shade700, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _incrementCounter(dua.name),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: _counterButtonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade200,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: _progressBarGradient,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }

  final List<Dua> _morningDuas = [
    Dua(
      'Ayetel Kürsi',
      'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
      targetCount: 1,
      meaning: 'Allah ki, O\'ndan başka ilah yoktur...',
    ),
    Dua(
      'Subhanallah',
      'سُبْحَانَ اللّٰهِ',
      targetCount: 33,
      meaning: 'Allah\'ı tüm eksikliklerden tenzih ederim',
    ),
    Dua(
      'Elhamdülillah',
      'الْحَمْدُ لِلّٰهِ',
      targetCount: 33,
      meaning: 'Hamd Allah\'a mahsustur',
    ),
    Dua(
      'Allahu Ekber',
      'اللّٰهُ أَكْبَرُ',
      targetCount: 34,
      meaning: 'Allah en büyüktür',
    ),
    Dua(
      'Lâ İlâhe İllallah',
      'لَا إِلٰهَ إِلَّا اللّٰهُ',
      targetCount: 100,
      meaning: 'Allah\'tan başka ilah yoktur',
    ),
    Dua(
      'Salavat-ı Şerife',
      'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
      targetCount: 100,
      meaning: 'Allah\'ım, Muhammed\'e ve âline salât eyle',
    ),
    Dua(
      'İstiğfar',
      'أَسْتَغْفِرُ اللَّهَ',
      targetCount: 100,
      meaning: 'Allah\'tan bağışlanma dilerim',
    ),
    Dua(
      'Hasbünallahu ve Ni\'mel Vekil',
      'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
      targetCount: 7,
      meaning: 'Allah bize yeter, O ne güzel vekildir',
    ),
  ];

  final List<Dua> _eveningDuas = [
    Dua(
      'Ayetel Kürsi',
      'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
      targetCount: 1,
      meaning: 'Allah ki, O\'ndan başka ilah yoktur...',
    ),
    Dua(
      'Subhanallah',
      'سُبْحَانَ اللّٰهِ',
      targetCount: 33,
      meaning: 'Allah\'ı tüm eksikliklerden tenzih ederim',
    ),
    Dua(
      'Elhamdülillah',
      'الْحَمْدُ لِلّٰهِ',
      targetCount: 33,
      meaning: 'Hamd Allah\'a mahsustur',
    ),
    Dua(
      'Allahu Ekber',
      'اللّٰهُ أَكْبَرُ',
      targetCount: 34,
      meaning: 'Allah en büyüktür',
    ),
    Dua(
      'Salavat-ı Şerife',
      'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
      targetCount: 100,
      meaning: 'Allah\'ım, Muhammed\'e ve âline salât eyle',
    ),
    Dua(
      'İstiğfar',
      'أَسْتَغْفِرُ اللَّهَ',
      targetCount: 100,
      meaning: 'Allah\'tan bağışlanma dilerim',
    ),
    Dua(
      'La Havle ve La Kuvvete İlla Billah',
      'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      targetCount: 100,
      meaning: 'Güç ve kuvvet ancak Allah\'tandır',
    ),
  ];

  final List<Dua> _generalDuas = [
    Dua(
      'Salavat-ı Şerife',
      'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
      targetCount: 100,
      meaning: 'Allah\'ım, Muhammed\'e ve âline salât eyle',
    ),
    Dua(
      'Tesbih',
      'سُبْحَانَ اللّٰهِ وَالْحَمْدُ لِلّٰهِ وَلَا إِلٰهَ إِلَّا اللّٰهُ وَاللّٰهُ أَكْبَرُ',
      targetCount: 100,
      meaning: 'Tesbih, tahmid, tehlil ve tekbir',
    ),
    Dua(
      'Subhanallah',
      'سُبْحَانَ اللّٰهِ',
      targetCount: 33,
      meaning: 'Allah\'ı tüm eksikliklerden tenzih ederim',
    ),
    Dua(
      'Elhamdülillah',
      'الْحَمْدُ لِلّٰهِ',
      targetCount: 33,
      meaning: 'Hamd Allah\'a mahsustur',
    ),
    Dua(
      'Allahu Ekber',
      'اللّٰهُ أَكْبَرُ',
      targetCount: 34,
      meaning: 'Allah en büyüktür',
    ),
    Dua(
      'Lâ İlâhe İllallah',
      'لَا إِلٰهَ إِلَّا اللّٰهُ',
      targetCount: 100,
      meaning: 'Allah\'tan başka ilah yoktur',
    ),
    Dua(
      'İstiğfar',
      'أَسْتَغْفِرُ اللَّهَ',
      targetCount: 100,
      meaning: 'Allah\'tan bağışlanma dilerim',
    ),
    Dua(
      'Hasbünallahu ve Ni\'mel Vekil',
      'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
      targetCount: 7,
      meaning: 'Allah bize yeter, O ne güzel vekildir',
    ),
    Dua(
      'La Havle ve La Kuvvete İlla Billah',
      'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      targetCount: 100,
      meaning: 'Güç ve kuvvet ancak Allah\'tandır',
    ),
    Dua(
      'Rabbena Atina',
      'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      targetCount: 1,
      meaning: 'Rabbimiz, bize dünyada da güzellik ver, ahirette de güzellik ver...',
    ),
    Dua(
      'Bismillah',
      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      targetCount: 0,
      meaning: 'Rahman ve Rahim olan Allah\'ın adıyla',
    ),
  ];
}

class Dua {
  final String name;
  final String arabic;
  final int targetCount;
  final String? meaning;

  Dua(this.name, this.arabic, {this.targetCount = 0, this.meaning});
}
