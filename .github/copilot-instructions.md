# Islami App - AI Coding Agent Instructions

## Project Overview
This is an **Islamic mobile application** built with Flutter, featuring prayer times, Qibla direction, Quran reading, and Dua/Zikir (supplications). The app emphasizes modern UI/UX with glassmorphism, gradient backgrounds, and smooth animations. Turkish language is used for UI text.

**Key Dependencies:** Flutter SDK 3.0+, http, google_fonts, animate_do, flutter_staggered_animations, glassmorphism, flutter_compass, geolocator, audioplayers

## Architecture & Code Organization

### Page Structure Pattern
- **4 main pages** accessed via `IndexedStack` in bottom navigation (`lib/main.dart`):
  - `TimesPage` (Vakitler) - Prayer times [MISSING - needs implementation]
  - `QiblaPage` (Kıble) - Compass for Qibla direction
  - `QuranPage` (Kur'an) - Quran surahs listing
  - `DuaZikirPage` (Dua & Zikir) - Supplications with counter

- Each page follows the pattern:
  ```dart
  GradientBackground(
    colors: [AppTheme.pageGradientStart, AppTheme.pageGradientEnd],
    child: SafeArea(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [_buildHeader(), _buildContent()...]
      )
    )
  )
  ```

### Design System (`lib/theme/app_theme.dart`)
- **Centralized theming** - All colors, gradients, and text styles defined here
- **Page-specific gradients:** `prayerGradient`, `qiblaGradient`, `quranGradient`, `duaGradient`
- **Typography:** Uses Google Fonts (Poppins for UI, Amiri for Arabic text)
- **Theme modes:** Both light and dark themes configured (currently defaults to light)
- When adding new colors/gradients, define them in `AppTheme` class, don't use hardcoded values

### Widget Library (`lib/widgets/`)
Reusable UI components:
- **`GlassCard`** - Glassmorphism effect with backdrop blur (20-30 blur, 0.2-0.3 opacity)
- **`GradientBackground`** - Full-screen gradient container wrapper
- **`AnimatedButton`** - Pressable button with scale animation and gradient support
- **`ShimmerLoader`, `ModernAnimations`** - Loading and particle effects

**Animation Pattern:** Use `animate_do` package (FadeInDown, FadeInUp, Pulse) for page headers and cards

### Services Layer
**`McpClient` (`lib/services/mcp_client.dart`):**
- HTTP client for communicating with local MCP (Model Context Protocol) server at `localhost:3333`
- Method: `generate(String prompt, {String model = 'gemini-2.0-flash'})` 
- Built-in retry logic (3 attempts with exponential backoff)
- Used for AI-powered content generation (not currently integrated in UI)

## Development Workflows

### Running the App
```powershell
flutter pub get              # Install dependencies
flutter run                  # Run on connected device/emulator
flutter run -d chrome        # Run web version
flutter build apk            # Build Android APK
```

### Common Issues
- **TimesPage missing:** Import exists in `main.dart` but file doesn't exist yet - create in `lib/pages/times_page.dart`
- **Android build:** Uses Kotlin Gradle Plugin with Java 17 target
- **Permissions needed:** Location (Qibla/prayer times), compass sensors - configure in `AndroidManifest.xml` and `Info.plist`

### Testing
```powershell
flutter test                 # Run all tests
flutter analyze              # Static analysis with flutter_lints
```

## Code Conventions

### UI Patterns
1. **Always wrap pages in `GradientBackground` + `SafeArea`**
2. **Use `CustomScrollView` with slivers** for scrollable content
3. **Add bottom padding (100px)** to account for floating bottom nav: `SliverToBoxAdapter(child: SizedBox(height: 100))`
4. **Animations:** FadeInDown for headers, FadeInUp for cards, AnimationControllers for continuous animations
5. **Turkish UI text** - All visible strings should be in Turkish (e.g., 'Vakitler', 'Kıble')

### State Management
- Currently using **StatefulWidget** with `setState()`
- TabController pattern: See `DuaZikirPage` for 3-tab layout example
- AnimationController pattern: See `QiblaPage` for continuous animations with `TickerProviderStateMixin`

### File Naming
- `snake_case` for all Dart files
- Pages: `*_page.dart` in `lib/pages/`
- Widgets: descriptive names in `lib/widgets/`
- Services: `*_client.dart` or `*_service.dart` in `lib/services/`

### Arabic Text Handling
- Use `AppTheme.arabicText` style (Amiri font, 24px, w600)
- RTL support not explicitly configured - add if needed with `Directionality` widget

## External Integrations

### Sensor/Hardware Access
- **Compass:** `flutter_compass` package for Qibla direction
- **Location:** `geolocator` + `permission_handler` for prayer time calculations
- **Audio:** `audioplayers` for playing adhans/duas (not yet implemented)
- **Haptic feedback:** `HapticFeedback.lightImpact()` for counter interactions

### Data Sources
- **Quran data:** Currently hardcoded list in `QuranPage` - expand to full 114 surahs
- **Duas:** Hardcoded in `DuaZikirPage` (_morningDuas, _eveningDuas, _generalDuas)
- **Prayer times:** Not implemented - needs API integration or local calculation library

## Missing/Incomplete Features
1. **TimesPage** - Create prayer times page with API integration
2. **Prayer time calculations** - Integrate calculation library or API
3. **Persistent storage** - `shared_preferences` added but not used (save last read Quran position, counters)
4. **Audio playback** - `audioplayers` added but not integrated
5. **Full Quran content** - Only 10 surahs listed, need all 114
6. **Localization** - Turkish hardcoded, consider adding i18n support

## When Adding New Features
- Define colors/gradients in `AppTheme` first
- Create reusable widgets in `lib/widgets/` if needed across pages
- Follow the page structure pattern with GradientBackground + CustomScrollView
- Add animations using `animate_do` or AnimationController
- Use `GlassCard` for elevated content on gradient backgrounds
- Test on both Android and iOS if modifying native permissions/sensors
