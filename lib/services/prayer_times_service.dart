import 'package:adhan/adhan.dart';

class PrayerTimesService {
  // Al-Hawamdeya coordinates
  static const double _latitude = 29.8967;
  static const double _longitude = 31.2631;

  /// Calculates prayer times offline for Al-Hawamdeya based on current date
  static PrayerTimes calculatePrayerTimes() {
    final coordinates = Coordinates(_latitude, _longitude);
    
    // Egyptian General Authority of Survey parameters
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi; // Standard Shafi'i madhab for Egypt (affects Asr)

    final dateComponents = DateComponents.from(DateTime.now());
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);
    
    return prayerTimes;
  }
}
