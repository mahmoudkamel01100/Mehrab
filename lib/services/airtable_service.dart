import 'dart:convert';
import 'package:http/http.dart' as http;

class AirtableService {
  static const String _apiKey = 'patbQBh65alVVwMju.8ca4c598d1db7e728b4224c58b20958ba3c87717e2ec4e1e02d46cce6af09ada';
  static const String _baseId = 'appAqknF6wbsid5Xu';
  static const String _tableName = 'Qoran';

  // Cache: { columnName: { surahNum: url } }
  static final Map<String, Map<String, String>> _airtableData = {};

  static final List<String> _surahNames = [
    "الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة", "الأنعام", "الأعراف", "الأنفال", "التوبة", "يونس",
    "هود", "يوسف", "الرعد", "إبراهيم", "الحجر", "النحل", "الإسراء", "الكهف", "مريم", "طه",
    "الأنبياء", "الحج", "المؤمنون", "النور", "الفرقان", "الشعراء", "النمل", "القصص", "العنكبوت", "الروم",
    "لقمان", "السجدة", "الأحزاب", "سبأ", "فاطر", "يس", "الصافات", "ص", "الزمر", "غافر",
    "فصلت", "الشورى", "الزخرف", "الدخان", "الجاثية", "الأحقاف", "محمد", "الفتح", "الحجرات", "ق",
    "الذاريات", "الطور", "النجم", "القمر", "الرحمن", "الواقعة", "الحديد", "المجادلة", "الحشر", "الممتحنة",
    "الصف", "الجمعة", "المنافقون", "التغابن", "الطلاق", "التحريم", "الملك", "القلم", "الحاقة", "المعارج",
    "نوح", "الجن", "المزمل", "المدثر", "القيامة", "الإنسان", "المرسلات", "النبأ", "النازعات", "عبس",
    "التكوير", "الانفطار", "المطففين", "الانشقاق", "البروج", "الطارق", "الأعلى", "الغاشية", "الفجر", "البلد",
    "الشمس", "الليل", "الضحى", "الشرح", "التين", "العلق", "القدر", "البينة", "الزلزلة", "العاديات",
    "القارعة", "التكاثر", "العصر", "الهمزة", "الفيل", "قريش", "الماعون", "الكوثر", "الكافرون", "النصر",
    "المسد", "الإخلاص", "الفلق", "الناس"
  ];

  static final Map<String, String> _reciterIdToAirtableColumn = {
    'h1': 'حمدى أبو الدهب',
    'h2': 'محمود عبد السلام',
    'h3': 'محمد حسنى',
    'h4': 'محمد جمعة',
    'h5': 'حنفى محمود',
    'h6': 'عبدالرحمن مصطفى',
    'e1': 'محمد صديق المنشاوى',
    'e2': 'محمد الطبلاوى',
    'e3': 'أحمد نعينع',
    'e4': 'عبدالله كامل',
    'e5': 'عبدالباسط عبدالصمد1',
    'e6': 'عبدالباسط عبدالصمد2',
    'e7': 'محمود خليل الحصرى1',
    'e8': 'محمود خليل الحصرى2',
    'e9': 'محمود على البنا',
    'e10': 'أحمد محمد عامر',
    's1': 'محمد على الحذيفى',
    's2': 'أحمد العجمى',
    's3': 'سعد الغامدى',
    's4': 'سعود الشريم',
    's5': 'عبدالرحمن السديس',
    's6': 'ماهر المعيقلى',
    's7': 'محمد أيوب',
    's8': 'ناصر القطامى',
    's9': 'ياسر الدوسرى'
  };

  static String _normalizeArabic(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'^سورة\s+'), '')
        .trim()
        .replaceAll(RegExp(r'[أإآ]'), 'ا')
        .replaceAll(RegExp(r'ة'), 'ه')
        .replaceAll(RegExp(r'[ّ]'), '');
  }

  static String _cleanAudioUrl(String url) {
    return url.replaceAll(RegExp(r'https?://ia\d+\.us\.archive\.org/\d+/items/', caseSensitive: false), 'https://archive.org/download/');
  }

  // Fetch Airtable records in background
  static Future<void> fetchAirtableRecords([String offset = '']) async {
    final String urlStr = 'https://api.airtable.com/v0/$_baseId/${Uri.encodeComponent(_tableName)}?pageSize=100' +
        (offset.isNotEmpty ? '&offset=$offset' : '');
    
    try {
      final response = await http.get(
        Uri.parse(urlStr),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List records = data['records'] ?? [];
        
        for (var record in records) {
          final fields = record['fields'] ?? {};
          final String? soraName = fields['sora'];
          if (soraName == null) continue;

          final String normalized = _normalizeArabic(soraName);
          final int surahIndex = _surahNames.indexWhere((name) => _normalizeArabic(name) == normalized);

          if (surahIndex != -1) {
            final String surahNum = (surahIndex + 1).toString().padLeft(3, '0');
            
            fields.forEach((key, value) {
              if (key != 'sora') {
                if (!_airtableData.containsKey(key)) {
                  _airtableData[key] = {};
                }
                _airtableData[key]![surahNum] = _cleanAudioUrl(value.toString());
              }
            });
          }
        }

        final String nextOffset = data['offset'] ?? '';
        if (nextOffset.isNotEmpty) {
          await fetchAirtableRecords(nextOffset);
        } else {
          print('Airtable loaded successfully in Flutter.');
        }
      } else {
        print('Airtable HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Airtable error: $e');
    }
  }

  // Resolve url
  static String? getAudioUrl(String reciterId, String surahNum) {
    final String? columnName = _reciterIdToAirtableColumn[reciterId];
    if (columnName != null && _airtableData.containsKey(columnName)) {
      return _airtableData[columnName]![surahNum];
    }
    return null;
  }

  // Fetch dynamic custom tables (such as Dr. Saad Hamouda's tables)
  static Future<List<Map<String, dynamic>>> fetchCustomTable(String tableName) async {
    final String urlStr = 'https://api.airtable.com/v0/$_baseId/${Uri.encodeComponent(tableName)}?pageSize=100';
    List<Map<String, dynamic>> results = [];
    String offset = '';
    
    try {
      do {
        final String fetchUrl = urlStr + (offset.isNotEmpty ? '&offset=$offset' : '');
        final response = await http.get(
          Uri.parse(fetchUrl),
          headers: {
            'Authorization': 'Bearer $_apiKey',
          },
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List records = data['records'] ?? [];
          for (var record in records) {
            final fields = record['fields'] ?? {};
            results.add(Map<String, dynamic>.from(fields));
          }
          offset = data['offset'] ?? '';
        } else {
          print('Airtable HTTP error for $tableName: ${response.statusCode}');
          break;
        }
      } while (offset.isNotEmpty);
    } catch (e) {
      print('Airtable error fetching custom table $tableName: $e');
    }
    
    return results;
  }
}
