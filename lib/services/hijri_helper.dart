import 'package:hijri/hijri_calendar.dart';

class HijriHelper {
  /// Converts Gregorian date to Hijri accurately using the hijri package
  static String getTodayHijri() {
    try {
      HijriCalendar.setLocal('ar');
      var today = HijriCalendar.now();
      return "${today.hDay} ${today.getLongMonthName()} ${today.hYear} هـ";
    } catch (e) {
      return "---";
    }
  }
}
