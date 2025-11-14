import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

/// Shimmer loading effect widget for skeleton screens
/// 
/// Usage:
/// ```dart
/// ShimmerLoader(
///   width: 200,
///   height: 20,
///   borderRadius: BorderRadius.circular(8),
/// )
/// ```
class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isDark;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final useDark = isDark || brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: useDark 
          ? AppTheme.shimmerBaseColorDark 
          : AppTheme.shimmerBaseColor,
      highlightColor: useDark
          ? AppTheme.shimmerHighlightColorDark
          : AppTheme.shimmerHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: useDark 
              ? AppTheme.midnightBlue 
              : AppTheme.pearlGray,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Pre-built shimmer card for loading states
/// 
/// Shows a card with multiple shimmer lines to simulate content loading
class ShimmerCard extends StatelessWidget {
  final bool isDark;
  
  const ShimmerCard({
    super.key,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final useDark = isDark || brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.all(16),
      color: useDark ? AppTheme.midnightBlue : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoader(
              width: double.infinity, 
              height: 20,
              isDark: useDark,
            ),
            const SizedBox(height: 12),
            ShimmerLoader(
              width: 200, 
              height: 16,
              isDark: useDark,
            ),
            const SizedBox(height: 8),
            ShimmerLoader(
              width: 150, 
              height: 16,
              isDark: useDark,
            ),
          ],
        ),
      ),
    );
  }
}
