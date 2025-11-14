import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';

class DuaZikirPage extends StatefulWidget {
  const DuaZikirPage({super.key});

  @override
  State<DuaZikirPage> createState() => _DuaZikirPageState();
}

class _DuaZikirPageState extends State<DuaZikirPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, int> _counters = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _incrementCounter(String duaName) {
    HapticFeedback.lightImpact();
    setState(() {
      _counters[duaName] = (_counters[duaName] ?? 0) + 1;
    });
  }

  void _resetCounter(String duaName) {
    HapticFeedback.mediumImpact();
    setState(() {
      _counters[duaName] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: [
          AppTheme.duaGradientStart,
          AppTheme.duaGradientEnd,
        ],
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: BouncingScrollPhysics(),
                  children: [
                    _buildDuaList(_morningDuas),
                    _buildDuaList(_eveningDuas),
                    _buildDuaList(_generalDuas),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: Duration(milliseconds: 800),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 12),
            Text(
              'Dua & Zikir',
              style: AppTheme.heading1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.2),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [AppTheme.secondaryGold, Color(0xFFF5A623)],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        labelStyle: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        tabs: [
          Tab(text: 'Sabah'),
          Tab(text: 'Akşam'),
          Tab(text: 'Genel'),
        ],
      ),
    );
  }

  Widget _buildDuaList(List<Dua> duas) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(20),
      itemCount: duas.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: 50,
            child: FadeInAnimation(
              child: _buildDuaCard(duas[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDuaCard(Dua dua) {
    final count = _counters[dua.name] ?? 0;
    final progress = dua.targetCount > 0 ? (count / dua.targetCount).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: GlassCard(
        blur: 20,
        opacity: 0.3,
        padding: EdgeInsets.all(20),
        child: Column(
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
                        style: AppTheme.heading3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (dua.meaning != null) ...[
                        SizedBox(height: 8),
                        Text(
                          dua.meaning!,
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                dua.arabic,
                style: AppTheme.arabicText.copyWith(
                  color: Colors.white,
                  height: 1.8,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            if (dua.targetCount > 0) ...[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$count / ${dua.targetCount}',
                    style: AppTheme.heading2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _resetCounter(dua.name),
                        icon: Icon(Icons.refresh, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _incrementCounter(dua.name),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.secondaryGold,
                                Color(0xFFF5A623),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.secondaryGold.withOpacity(0.5),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [AppTheme.secondaryGold, Color(0xFFF5A623)],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
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
  ];

  final List<Dua> _eveningDuas = [
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
  ];
}

class Dua {
  final String name;
  final String arabic;
  final int targetCount;
  final String? meaning;

  Dua(this.name, this.arabic, {this.targetCount = 0, this.meaning});
}
