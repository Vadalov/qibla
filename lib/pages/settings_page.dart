import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = [
      _SettingItem('Konum Ayarları', Icons.location_on_rounded, 'Otomatik / Manuel'),
      _SettingItem('Bildirimler', Icons.notifications_active, 'Sessiz zamanlar'),
      _SettingItem('Tema', Icons.dark_mode, 'Koyu / Cam efekt'),
      _SettingItem('Dil', Icons.language, 'Türkçe'),
      _SettingItem('Hakkında', Icons.info_outline, 'Sürüm 1.0.0'),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A111F), Color(0xFF0E1A2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: const [
                    Text(
                      'Ayarlar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemBuilder: (context, index) => _GlassSettingCard(item: settings[index]),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: settings.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassSettingCard extends StatelessWidget {
  const _GlassSettingCard({required this.item});

  final _SettingItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.oceanBlue, AppTheme.twilightPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(item.icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingItem {
  const _SettingItem(this.title, this.icon, this.subtitle);

  final String title;
  final IconData icon;
  final String subtitle;
}
