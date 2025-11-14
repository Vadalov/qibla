import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String label;
  final bool isUsingDefault;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.isUsingDefault,
  });
}

class LocationService {
  static const double _defaultLatitude = 41.0082;
  static const double _defaultLongitude = 28.9784;
  static const String _defaultLabel = 'İstanbul, Türkiye';

  /// Get the current user location if permission is granted and services
  /// are enabled. Otherwise, fall back to Istanbul as a sensible default.
  Future<LocationResult> getCurrentLocation() async {
    double latitude = _defaultLatitude;
    double longitude = _defaultLongitude;
    String label = _defaultLabel;
    bool isDefault = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult(
          latitude: latitude,
          longitude: longitude,
          label: label,
          isUsingDefault: isDefault,
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        latitude = position.latitude;
        longitude = position.longitude;
        label = 'Bulunduğunuz konum';
        isDefault = false;
      }
    } catch (_) {
      // If anything goes wrong, we keep the default Istanbul location
    }

    return LocationResult(
      latitude: latitude,
      longitude: longitude,
      label: label,
      isUsingDefault: isDefault,
    );
  }
}


