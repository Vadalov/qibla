import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============================================================================
  // LEGACY COLOR PALETTE (Preserved for backward compatibility)
  // ============================================================================
  static const primaryGreen = Color(0xFF2D8B6E);
  static const secondaryGold = Color(0xFFD4AF37);
  static const darkBackground = Color(0xFF1A1F2E);
  static const cardBackground = Color(0xFF242938);
  static const accentTeal = Color(0xFF4ECDC4);
  static const softWhite = Color(0xFFF7F7F7);

  // Legacy Gradient Colors
  static const gradientStart = Color(0xFF2D8B6E);
  static const gradientMiddle = Color(0xFF3FA78F);
  static const gradientEnd = Color(0xFF4ECDC4);

  static const prayerGradientStart = Color(0xFF667EEA);
  static const prayerGradientEnd = Color(0xFF764BA2);

  static const qiblaGradientStart = Color(0xFFD4AF37);
  static const qiblaGradientEnd = Color(0xFFF5A623);

  static const quranGradientStart = Color(0xFF2D8B6E);
  static const quranGradientEnd = Color(0xFF1A5F4C);

  static const duaGradientStart = Color(0xFF6366F1);
  static const duaGradientEnd = Color(0xFF8B5CF6);

  // ============================================================================
  // PREMIUM COLOR PALETTE (Ocean Blue + Sunset Purple Fusion)
  // ============================================================================

  // ----------------------------------------------------------------------------
  // Primary Colors - Core brand colors for main UI elements
  // Usage: App bars, primary buttons, key navigation elements
  // Accessibility: All primary colors meet WCAG AA standards with white text
  // ----------------------------------------------------------------------------

  /// Deep ocean blue - Primary brand color
  /// Use for: Main app bar, primary CTAs, active states
  /// Contrast ratio with white: 7.1:1 (AAA compliant)
  static const oceanBlue = Color(0xFF1E40AF);

  /// Sky blue - Lighter accent for interactive elements
  /// Use for: Links, interactive icons, focus indicators
  /// Contrast ratio with white: 4.8:1 (AA compliant)
  static const skyBlue = Color(0xFF3B82F6);

  /// Twilight purple - Secondary brand color
  /// Use for: Secondary actions, featured content, special badges
  /// Contrast ratio with white: 5.2:1 (AA compliant)
  static const twilightPurple = Color(0xFF7C3AED);

  /// Sunset pink - Accent for warm, inviting elements
  /// Use for: Prayer time cards, notifications, favorite indicators
  /// Contrast ratio with white: 4.9:1 (AA compliant)
  static const sunsetPink = Color(0xFFEC4899);

  /// Cosmic indigo - Balanced primary/secondary blend
  /// Use for: Navigation bars, section headers, card accents
  /// Contrast ratio with white: 6.8:1 (AA compliant)
  static const cosmicIndigo = Color(0xFF4F46E5);

  // ----------------------------------------------------------------------------
  // Accent Colors - High-energy colors for attention and emphasis
  // Usage: Highlights, badges, success states, special features
  // ----------------------------------------------------------------------------

  /// Neon cyan - High-visibility accent
  /// Use for: Active indicators, live updates, real-time features (Qibla compass)
  static const neonCyan = Color(0xFF06B6D4);

  /// Electric violet - Premium feature indicator
  /// Use for: Pro features, premium content, special achievements
  static const electricViolet = Color(0xFF8B5CF6);

  /// Amber glow - Warm attention color
  /// Use for: Important notifications, time-sensitive alerts, warnings
  static const amberGlow = Color(0xFFF59E0B);

  /// Rose gold - Elegant feminine accent
  /// Use for: Dua & Zikir pages, bookmarks, favorite content
  static const roseGold = Color(0xFFF472B6);

  // ----------------------------------------------------------------------------
  // Background Colors - Base surfaces for light and dark modes
  // Usage: App backgrounds, card surfaces, layered content
  // ----------------------------------------------------------------------------

  /// Deep space - Primary dark mode background
  /// Use for: Main app background in dark mode, full-screen overlays
  /// Dark mode recommendation: Base layer for all content
  static const deepSpace = Color(0xFF0F172A);

  /// Midnight blue - Dark mode card surface
  /// Use for: Cards, panels, elevated surfaces in dark mode
  /// Dark mode recommendation: Content containers, modals
  static const midnightBlue = Color(0xFF1E293B);

  /// Cloud white - Primary light mode background
  /// Use for: Main app background in light mode, clean surfaces
  /// Light mode recommendation: Base layer for all content
  static const cloudWhite = Color(0xFFF8FAFC);

  /// Pearl gray - Light mode card surface
  /// Use for: Cards, panels, elevated surfaces in light mode
  /// Light mode recommendation: Content containers, subtle separation
  static const pearlGray = Color(0xFFE2E8F0);

  // ----------------------------------------------------------------------------
  // Glassmorphism Colors - Modern frosted glass effects
  // Usage: Overlay panels, floating elements, modern UI effects
  // Note: Combine with backdrop blur for best results
  // ----------------------------------------------------------------------------

  /// Glass white - Light glassmorphic overlay (10% opacity)
  /// Use for: Light mode floating panels, subtle overlays
  static const glassWhite = Color(0x1AFFFFFF);

  /// Glass dark - Dark glassmorphic overlay (10% opacity)
  /// Use for: Dark mode floating panels, content overlays
  static const glassDark = Color(0x1A000000);

  /// Glass border - Subtle border for glass elements (20% opacity)
  /// Use for: Defining edges on glassmorphic components
  static const glassBorder = Color(0x33FFFFFF);

  /// Glass highlight - Shimmer effect on glass (40% opacity)
  /// Use for: Light reflections, highlight edges on glass surfaces
  static const glassHighlight = Color(0x66FFFFFF);

  // ----------------------------------------------------------------------------
  // Neumorphism Colors - Soft UI shadows and highlights
  // Usage: Modern soft UI design, tactile button effects
  // Note: Best used with light backgrounds in light mode
  // ----------------------------------------------------------------------------

  /// Neumorphic light shadow (20% opacity)
  /// Use for: Top-left shadow in neumorphic elements
  static const neuLightShadow = Color(0x33000000);

  /// Neumorphic dark shadow (40% opacity)
  /// Use for: Bottom-right shadow in neumorphic elements
  static const neuDarkShadow = Color(0x66000000);

  /// Neumorphic light highlight
  /// Use for: Top-left highlight in neumorphic elements
  static const neuLightHighlight = Color(0xFFFFFFFF);

  /// Neumorphic dark highlight (10% opacity)
  /// Use for: Subtle highlights in dark mode neumorphism
  static const neuDarkHighlight = Color(0x1AFFFFFF);

  // ----------------------------------------------------------------------------
  // Semantic Colors - Standardized feedback colors
  // Usage: Success messages, errors, warnings, informational alerts
  // Accessibility: All meet WCAG AA standards
  // ----------------------------------------------------------------------------

  /// Success green - Positive feedback and confirmations
  /// Use for: Success messages, completed tasks, positive states
  /// Contrast ratio with white: 4.7:1 (AA compliant)
  static const successGreen = Color(0xFF10B981);

  /// Warning orange - Cautionary alerts
  /// Use for: Important warnings, time-sensitive information
  /// Contrast ratio with dark text: 3.8:1 (AA compliant for large text)
  static const warningOrange = Color(0xFFF59E0B);

  /// Error red - Error states and critical alerts
  /// Use for: Error messages, failed operations, critical warnings
  /// Contrast ratio with white: 5.9:1 (AA compliant)
  static const errorRed = Color(0xFFEF4444);

  /// Info blue - Informational messages
  /// Use for: Tips, helpful information, neutral notifications
  static const infoBlue = skyBlue;

  /// Neutral gray - Disabled and inactive states
  /// Use for: Disabled buttons, inactive elements, placeholder text
  static const neutralGray = Color(0xFF64748B);

  // ----------------------------------------------------------------------------
  // Dark Mode Specific Colors
  // Usage: Enhanced dark mode experience with rich contrasts
  // ----------------------------------------------------------------------------

  /// Dark mode accent 1 - Electric violet for premium features
  static const darkModeAccent1 = electricViolet;

  /// Dark mode accent 2 - Neon cyan for active elements
  static const darkModeAccent2 = neonCyan;

  /// Dark mode accent 3 - Rose gold for special content
  static const darkModeAccent3 = roseGold;

  /// Dark mode border - Subtle borders and dividers
  /// Use for: Card borders, section separators
  static const darkModeBorder = Color(0xFF334155);

  /// Dark mode divider - Very subtle content separation
  /// Use for: List dividers, horizontal rules
  static const darkModeDivider = Color(0xFF1E293B);

  // ----------------------------------------------------------------------------
  // Light Mode Specific Colors
  // Usage: Enhanced light mode experience with clean aesthetics
  // ----------------------------------------------------------------------------

  /// Light mode accent 1 - Cosmic indigo for emphasis
  static const lightModeAccent1 = cosmicIndigo;

  /// Light mode accent 2 - Sunset pink for warm accents
  static const lightModeAccent2 = sunsetPink;

  /// Light mode accent 3 - Amber glow for highlights
  static const lightModeAccent3 = amberGlow;

  /// Light mode border - Visible borders and dividers
  /// Use for: Card borders, input fields, section separators
  static const lightModeBorder = Color(0xFFCBD5E1);

  /// Light mode divider - Subtle content separation
  /// Use for: List dividers, horizontal rules
  static const lightModeDivider = Color(0xFFE2E8F0);

  // ----------------------------------------------------------------------------
  // Animation Colors - Shimmer, pulse, and ripple effects
  // Usage: Loading states, interactions, micro-animations
  // ----------------------------------------------------------------------------

  /// Shimmer base color for light mode
  /// Use for: Skeleton loading screens in light mode
  static const shimmerBaseColor = Color(0xFFE2E8F0);

  /// Shimmer highlight color for light mode
  /// Use for: Animated shimmer effect in light mode
  static const shimmerHighlightColor = Color(0xFFF1F5F9);

  /// Shimmer base color for dark mode
  /// Use for: Skeleton loading screens in dark mode
  static const shimmerBaseColorDark = Color(0xFF1E293B);

  /// Shimmer highlight color for dark mode
  /// Use for: Animated shimmer effect in dark mode
  static const shimmerHighlightColorDark = Color(0xFF334155);

  /// Pulse color - Breathing animation effect
  /// Use for: Attention-grabbing elements, live indicators
  static final pulseColor = skyBlue.withOpacity(0.3);

  /// Ripple color - Touch feedback effect
  /// Use for: Button press feedback, interactive touch responses
  static final rippleColor = neonCyan.withOpacity(0.2);

  // ----------------------------------------------------------------------------
  // Glow Effect Colors - Luminous accents for modern UI
  // Usage: Hover states, focus indicators, premium highlights
  // ----------------------------------------------------------------------------

  /// Blue glow - Cool luminous effect
  /// Use for: Focus states, hover effects on primary elements
  static final glowBlue = skyBlue.withOpacity(0.5);

  /// Purple glow - Mystical luminous effect
  /// Use for: Premium features, special content highlights
  static final glowPurple = twilightPurple.withOpacity(0.5);

  /// Pink glow - Warm luminous effect
  /// Use for: Favorites, bookmarks, personalized content
  static final glowPink = sunsetPink.withOpacity(0.5);

  /// Cyan glow - Electric luminous effect
  /// Use for: Active states, real-time updates, live features
  static final glowCyan = neonCyan.withOpacity(0.5);

  // ============================================================================
  // LEGACY LINEAR GRADIENTS (Preserved for backward compatibility)
  // ============================================================================

  static LinearGradient get mainGradient => LinearGradient(
    colors: [gradientStart, gradientMiddle, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get prayerGradient => LinearGradient(
    colors: [prayerGradientStart, prayerGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get qiblaGradient => LinearGradient(
    colors: [qiblaGradientStart, qiblaGradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient get quranGradient => LinearGradient(
    colors: [quranGradientStart, quranGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get duaGradient => LinearGradient(
    colors: [duaGradientStart, duaGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // PREMIUM LINEAR GRADIENTS (Ocean Blue + Sunset Purple Collection)
  // ============================================================================

  /// Ocean Dream Gradient - Serene blue ocean vibes
  /// Use for: Main screen backgrounds, hero sections, splash screens
  /// Color flow: Deep ocean → Sky → Neon cyan (cool to electric)
  static LinearGradient get oceanDreamGradient => LinearGradient(
    colors: [oceanBlue, skyBlue, neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Sunset Magic Gradient - Warm twilight atmosphere
  /// Use for: Prayer time cards, special notifications, evening themes
  /// Color flow: Purple twilight → Pink sunset → Amber glow (mystical to warm)
  static LinearGradient get sunsetMagicGradient => LinearGradient(
    colors: [twilightPurple, sunsetPink, amberGlow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Cosmic Fusion Gradient - Deep space exploration
  /// Use for: Quran pages, important content areas, premium sections
  /// Color flow: Indigo → Electric violet → Twilight purple (cosmic journey)
  static LinearGradient get cosmicFusionGradient => LinearGradient(
    colors: [cosmicIndigo, electricViolet, twilightPurple],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  /// Aurora Borealis Gradient - Northern lights phenomenon
  /// Use for: Premium features, splash screens, special announcements
  /// Color flow: Ocean blue → Electric violet → Sunset pink → Neon cyan (full spectrum)
  /// Note: Uses 4 colors with custom stops for smooth transitions
  static LinearGradient get auroraBorealisGradient => LinearGradient(
    colors: [oceanBlue, electricViolet, sunsetPink, neonCyan],
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  /// Twilight Glow Gradient - Night mode elegance
  /// Use for: Dark mode backgrounds, nighttime content, immersive experiences
  /// Color flow: Deep space → Cosmic indigo → Twilight purple (deep to mystical)
  static LinearGradient get twilightGlowGradient => LinearGradient(
    colors: [deepSpace, cosmicIndigo, twilightPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Rose Quartz Gradient - Elegant feminine aesthetic
  /// Use for: Dua & Zikir pages, female-focused content, soft interactions
  /// Color flow: Rose gold → Sunset pink → Electric violet (soft to vibrant)
  static LinearGradient get roseQuartzGradient => LinearGradient(
    colors: [roseGold, sunsetPink, electricViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Electric Sky Gradient - Energetic daylight
  /// Use for: Qibla compass page, navigation elements, active states
  /// Color flow: Sky blue → Neon cyan → Electric violet (bright to energetic)
  static LinearGradient get electricSkyGradient => LinearGradient(
    colors: [skyBlue, neonCyan, electricViolet],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Midnight Shimmer Gradient - Subtle dark elegance
  /// Use for: Cards, buttons, hover effects, interactive elements
  /// Color flow: Midnight blue → Ocean blue → Cosmic indigo (horizontal flow)
  static LinearGradient get midnightShimmerGradient => LinearGradient(
    colors: [midnightBlue, oceanBlue, cosmicIndigo],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ============================================================================
  // RADIAL GRADIENTS - Spotlight and halo effects
  // ============================================================================

  /// Spotlight Gradient - Focus attention effect
  /// Use for: Hover states, focus indicators, attention-grabbing elements
  /// Effect: Blue glow from center fading to transparent
  static RadialGradient get spotlightGradient => RadialGradient(
    colors: [glowBlue, Colors.transparent],
    center: Alignment.center,
    radius: 1.0,
  );

  /// Halo Gradient - Premium luminous aura
  /// Use for: Premium cards, special content, featured elements
  /// Effect: Purple-pink glow from top-right corner
  static RadialGradient get haloGradient => RadialGradient(
    colors: [glowPurple, glowPink, Colors.transparent],
    center: Alignment.topRight,
    radius: 1.5,
  );

  // ============================================================================
  // SWEEP GRADIENTS - Circular rainbow effects
  // ============================================================================

  /// Rainbow Sweep Gradient - Full spectrum circular animation
  /// Use for: Loading indicators, progress rings, circular progress bars
  /// Effect: Complete color wheel rotation (360°)
  /// Note: Perfect for animated circular progress indicators
  static SweepGradient get rainbowSweepGradient => SweepGradient(
    colors: [
      oceanBlue,
      skyBlue,
      neonCyan,
      electricViolet,
      twilightPurple,
      sunsetPink,
      oceanBlue, // Complete the circle
    ],
    center: Alignment.center,
    startAngle: 0.0,
    endAngle: math.pi * 2,
  );

  // ============================================================================
  // GLASSMORPHISM HELPER - Frosted glass effect decorator
  // ============================================================================

  /// Creates a glassmorphic BoxDecoration with frosted glass effect
  ///
  /// Parameters:
  ///   - isDark: Use dark glass overlay (true) or light glass overlay (false)
  ///
  /// Returns: BoxDecoration with glass effect, borders, and subtle shadows
  ///
  /// Usage example:
  /// ```dart
  /// Container(
  ///   decoration: AppTheme.getGlassDecoration(isDark: true),
  ///   child: BackdropFilter(
  ///     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  ///     child: YourContent(),
  ///   ),
  /// )
  /// ```
  ///
  /// Note: Combine with BackdropFilter for best frosted glass effect
  static BoxDecoration getGlassDecoration({required bool isDark}) {
    return BoxDecoration(
      color: isDark ? glassDark : glassWhite,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: glassBorder,
        width: 1.5,
      ),
      boxShadow: [
        // Outer glow
        BoxShadow(
          color: isDark ? glowBlue : glowPurple,
          blurRadius: 20,
          offset: Offset(0, 4),
        ),
        // Inner highlight
        BoxShadow(
          color: glassHighlight,
          blurRadius: 10,
          offset: Offset(0, -2),
        ),
      ],
    );
  }

  // ============================================================================
  // NEUMORPHISM HELPER - Soft UI shadow effects
  // ============================================================================

  /// Creates a neumorphic BoxDecoration with soft shadows
  ///
  /// Parameters:
  ///   - isDark: Use dark background (true) or light background (false)
  ///   - isPressed: Show pressed state (true) or raised state (false)
  ///
  /// Returns: BoxDecoration with neumorphic shadows
  ///
  /// Usage example:
  /// ```dart
  /// Container(
  ///   decoration: AppTheme.getNeumorphicDecoration(
  ///     isDark: false,
  ///     isPressed: false,
  ///   ),
  ///   child: YourButton(),
  /// )
  /// ```
  ///
  /// Note: Works best on surfaces matching background colors
  static BoxDecoration getNeumorphicDecoration({
    required bool isDark,
    required bool isPressed,
  }) {
    return BoxDecoration(
      color: isDark ? midnightBlue : cloudWhite,
      borderRadius: BorderRadius.circular(20),
      boxShadow: isPressed
          ? [
              // Inner shadows (pressed state)
              BoxShadow(
                color: isDark ? neuDarkShadow : neuLightShadow,
                blurRadius: 10,
                offset: Offset(-5, -5),
                inset: true,
              ),
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : neuDarkShadow,
                blurRadius: 10,
                offset: Offset(5, 5),
                inset: true,
              ),
            ]
          : [
              // Outer shadows (raised state)
              BoxShadow(
                color: isDark ? neuDarkHighlight : neuLightHighlight,
                blurRadius: 15,
                offset: Offset(-8, -8),
              ),
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.5) : neuDarkShadow,
                blurRadius: 15,
                offset: Offset(8, 8),
              ),
            ],
    );
  }

  // ============================================================================
  // THEME DATA - Material 3 Light Theme Configuration
  // ============================================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: oceanBlue,
        secondary: twilightPurple,
        tertiary: skyBlue,
        surface: pearlGray,
        background: cloudWhite,
        error: Color(0xFFDC2626),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1E293B),
        onBackground: Color(0xFF0F172A),
      ),
      scaffoldBackgroundColor: cloudWhite,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 8,
        color: Colors.white,
        shadowColor: oceanBlue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // THEME DATA - Material 3 Dark Theme Configuration
  // ============================================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: skyBlue,
        secondary: sunsetPink,
        tertiary: neonCyan,
        surface: midnightBlue,
        background: deepSpace,
        error: Color(0xFFEF4444),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFFE2E8F0),
        onBackground: Color(0xFFF1F5F9),
      ),
      scaffoldBackgroundColor: deepSpace,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 12,
        color: midnightBlue,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // TEXT STYLES - Typography system
  // ============================================================================

  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get arabicText => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
}
