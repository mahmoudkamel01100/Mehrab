import 'quran_surah_meta.dart';
export 'quran_surah_meta.dart';
import 'quran_data/surahs_part_1.dart';
import 'quran_data/surahs_part_2.dart';
import 'quran_data/surahs_part_3.dart';
import 'quran_data/surahs_part_4.dart';
import 'quran_data/surahs_part_5.dart';

class QuranService {
  static const String basmala = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

  /// Returns metadata for all 114 Surahs
  static List<SurahInfo> getAllSurahs() {
    return QuranSurahMeta.surahs;
  }

  /// Returns metadata for a specific Surah (1..114)
  static SurahInfo? getSurahMeta(int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) return null;
    return QuranSurahMeta.surahs[surahNumber - 1];
  }

  /// Returns Arabic name of the Surah
  static String getSurahName(int surahNumber) {
    final meta = getSurahMeta(surahNumber);
    return meta != null ? meta.name : '';
  }

  /// Returns count of verses in the Surah
  static int getVerseCount(int surahNumber) {
    final meta = getSurahMeta(surahNumber);
    return meta != null ? meta.verseCount : 0;
  }

  /// Returns place of revelation (مكية / مدنية)
  static String getPlace(int surahNumber) {
    final meta = getSurahMeta(surahNumber);
    return meta != null ? meta.type : '';
  }

  /// Returns all verses of the requested Surah (1-indexed) directly from memory
  static List<String> getSurahVerses(int surahNumber) {
    if (surahNumber >= 1 && surahNumber <= 20) {
      return quranPart1[surahNumber] ?? [];
    } else if (surahNumber >= 21 && surahNumber <= 40) {
      return quranPart2[surahNumber] ?? [];
    } else if (surahNumber >= 41 && surahNumber <= 60) {
      return quranPart3[surahNumber] ?? [];
    } else if (surahNumber >= 61 && surahNumber <= 80) {
      return quranPart4[surahNumber] ?? [];
    } else if (surahNumber >= 81 && surahNumber <= 114) {
      return quranPart5[surahNumber] ?? [];
    }
    return [];
  }

  /// Returns a specific single verse (1-indexed)
  static String getVerse(int surahNumber, int verseNumber) {
    final verses = getSurahVerses(surahNumber);
    if (verseNumber >= 1 && verseNumber <= verses.length) {
      return verses[verseNumber - 1];
    }
    return '';
  }
}
