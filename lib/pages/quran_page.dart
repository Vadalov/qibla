import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: [
          AppTheme.quranGradientStart,
          AppTheme.quranGradientEnd,
        ],
        child: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              _buildHeader(),
              _buildLastRead(),
              _buildSurahList(),
              SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: FadeInDown(
        duration: Duration(milliseconds: 800),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.menu_book,
                size: 48,
                color: Colors.white,
              ),
              SizedBox(height: 12),
              Text(
                'Kur\'an-ı Kerim',
                style: AppTheme.heading1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '114 Sure',
                style: AppTheme.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastRead() {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: Duration(milliseconds: 800),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GlassCard(
            blur: 20,
            opacity: 0.3,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bookmark, color: AppTheme.secondaryGold, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Son Okunan',
                      style: AppTheme.heading3.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Al-Baqarah',
                  style: AppTheme.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Ayet 156 / 286',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 156 / 286,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [AppTheme.secondaryGold, Color(0xFFF5A623)],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahList() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: _buildSurahCard(_surahs[index]),
                ),
              ),
            );
          },
          childCount: _surahs.length,
        ),
      ),
    );
  }

  Widget _buildSurahCard(Surah surah) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: GlassCard(
        blur: 15,
        opacity: 0.2,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondaryGold,
                    Color(0xFFF5A623),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${surah.number}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.name,
                    style: AppTheme.heading3.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${surah.verses} Ayet • ${surah.revelation}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Text(
              surah.arabic,
              style: AppTheme.arabicText.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
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
