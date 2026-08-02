class HijriHelper {
  /// Converts Gregorian date to Hijri mathematically (Offline and accurate)
  static String getTodayHijri() {
    DateTime now = DateTime.now();
    int gYear = now.year;
    int gMonth = now.month;
    int gDay = now.day;

    if (gMonth < 3) {
      gYear -= 1;
      gMonth += 12;
    }

    int a = (gYear / 100).floor();
    int b = (a / 4).floor();
    double c = (2 - a + b).toDouble();
    double e = (365.25 * (gYear + 4716)).floorToDouble();
    double f = (30.6001 * (gMonth + 1)).floorToDouble();
    double jd = c + gDay + e + f - 1524.5;

    // Convert JD to Hijri
    double l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    
    int j = (((10985 - l) / 5316).floor() * ((50 - l) / 5316).floor()) + 
            (((l - 1) / 5669).floor() * (l / 5669).floor());
            
    l = l - (((30 - j) / 15).floor() * ((17 - j) / 25).floor() * 30) - 
        ((j / 30).floor() * 30) + 105;
        
    int hYear = 30 * n + j - 30;
    int hMonth = ((l * 24) / 709).floor();
    int hDay = (l - ((hMonth * 709) / 24).floor()).toInt();

    // Hijri Months list
    const List<String> months = [
      "محرم", "صفر", "ربيع الأول", "ربيع الآخر", "جمادى الأولى", "جمادى الآخرة",
      "رجب", "شعبان", "رمضان", "شوال", "ذو القعدة", "ذو الحجة"
    ];

    if (hMonth < 1 || hMonth > 12) return "---";
    return "$hDay ${months[hMonth - 1]} $hYear هـ";
  }
}
