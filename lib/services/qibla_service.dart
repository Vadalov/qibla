import 'dart:math' as math;

class QiblaService {
  // Kaaba coordinates
  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;

  /// Calculate Qibla direction (bearing) in degrees from North (0-360)
  /// for a given latitude and longitude.
  static double calculateQiblaBearing({
    required double latitude,
    required double longitude,
  }) {
    final lat1 = _degToRad(latitude);
    final lon1 = _degToRad(longitude);
    final lat2 = _degToRad(_kaabaLatitude);
    final lon2 = _degToRad(_kaabaLongitude);

    final dLon = lon2 - lon1;

    final y = math.sin(dLon);
    final x = math.cos(lat1) * math.tan(lat2) - math.sin(lat1) * math.cos(dLon);

    final bearing = math.atan2(y, x);
    final bearingDegrees = _radToDeg(bearing);

    // Normalize to 0-360
    return (bearingDegrees + 360) % 360;
  }

  /// Calculate distance to Kaaba in kilometers using the haversine formula.
  static double calculateDistanceToKaabaKm({
    required double latitude,
    required double longitude,
  }) {
    const earthRadiusKm = 6371.0;

    final lat1 = _degToRad(latitude);
    final lon1 = _degToRad(longitude);
    final lat2 = _degToRad(_kaabaLatitude);
    final lon2 = _degToRad(_kaabaLongitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    final c = 2 * math.atan2(math.sqrt(a as num), math.sqrt(1 - (a as num)));

    return earthRadiusKm * c;
  }

  static double _degToRad(double deg) => deg * (math.pi / 180.0);

  static double _radToDeg(double rad) => rad * (180.0 / math.pi);
}


