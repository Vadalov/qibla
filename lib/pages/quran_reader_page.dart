import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import '../services/quran_service.dart';
import 'quran_page.dart';

class QuranReaderPage extends StatefulWidget {
  final Surah surah;
  final StorageService storageService;
  final AudioService audioService;

  const QuranReaderPage({
    super.key,
    required this.surah,
    required this.storageService,
    required this.audioService,
  });

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  final QuranService _quranService = QuranService();
  List<QuranVerse>? _verses;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _saveLastRead();
    _loadVerses();
  }

  Future<void> _saveLastRead() async {
    await widget.storageService.init();
    await widget.storageService.setLastReadSurah(
      widget.surah.number,
      widget.surah.name,
    );
    await widget.storageService.setLastReadAyah(1);
  }

  Future<void> _loadVerses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final verses = await _quranService.getSurahVerses(widget.surah.number);
      if (mounted) {
        setState(() {
          _verses = verses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Ayetler yüklenirken bir hata oluştu.';
        });
      }
    }
  }

  Future<void> _playAudio() async {
    await widget.audioService.playQuranVerse(widget.surah.number, 1);
  }

  void _saveAyahPosition(int ayahNumber) async {
    await widget.storageService.init();
    await widget.storageService.setLastReadAyah(ayahNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? _buildLoading()
                  : _errorMessage != null
                      ? _buildError()
                      : _buildVerses(),
            ),
            if (!_isLoading && _errorMessage == null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: _playAudio,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Sûreyi Dinle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.quranGradientStart,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.quranGradientStart),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Bir hata oluştu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadVerses,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.quranGradientStart,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerses() {
    if (_verses == null || _verses!.isEmpty) {
      return Center(
        child: Text(
          'Ayetler bulunamadı',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVerses,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: _verses!.length,
        itemBuilder: (context, index) {
          final verse = _verses![index];
          return _buildVerseCard(verse);
        },
      ),
    );
  }

  Widget _buildVerseCard(QuranVerse verse) {
    return GestureDetector(
      onTap: () => _saveAyahPosition(verse.number),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppTheme.quranGradientStart,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${verse.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                verse.text,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 22,
                  height: 2.0,
                  fontFamily: 'Amiri',
                  letterSpacing: 1.5,
                ),
              ),
              if (verse.translation != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  verse.translation!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.quranGradientStart,
            AppTheme.quranGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.surah.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.surah.arabic,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.surah.verses} Ayet • ${widget.surah.revelation}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (!_isLoading && _errorMessage == null)
            IconButton(
              onPressed: _loadVerses,
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: 'Yenile',
            ),
        ],
      ),
    );
  }
}


