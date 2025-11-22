import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_glass_page.dart';
import 'pages/qibla_compass_page.dart';
import 'pages/dua_page.dart';
import 'pages/zikir_page.dart';
import 'pages/settings_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const IslamiApp());
}

class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İslami Mobil Uygulama',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomeGlassPage(),
    QiblaCompassPage(),
    DuaPage(),
    ZikirPage(),
    SettingsPage(),
  ];

  static const _navColors = [
    AppTheme.prayerGradientStart,
    AppTheme.qiblaGradientStart,
    AppTheme.duaGradientStart,
    AppTheme.roseGold,
    AppTheme.twilightPurple,
  ];

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = _navColors[index];

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          if (_currentIndex != index) {
            setState(() => _currentIndex = index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: const BoxConstraints(minWidth: 60, minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.white.withOpacity(0.14) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (index == 1)
                _buildQiblaGem(isSelected, color)
              else
                Icon(
                  icon,
                  color: isSelected ? color : Colors.white60,
                  size: 24,
                ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQiblaGem(bool isSelected, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            isSelected ? color : color.withOpacity(0.6),
            AppTheme.secondaryGold,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryGold.withOpacity(0.4),
            blurRadius: isSelected ? 16 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.explore, color: Colors.white, size: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xCC0F172A), Color(0xCC0B1222)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 40,
              offset: const Offset(0, -12),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.explore_outlined, 'Kıble'),
                _buildNavItem(2, Icons.auto_awesome_outlined, 'Dua'),
                _buildNavItem(3, Icons.brightness_low_rounded, 'Zikir'),
                _buildNavItem(4, Icons.settings_outlined, 'Ayarlar'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}