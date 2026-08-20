import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/quran_service.dart';
import 'quran_reader_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<Map<String, dynamic>> _allSurahs = [];
  List<Map<String, dynamic>> _filteredSurahs = [];
  final TextEditingController _searchController = TextEditingController();

  String? _lastReadSurahName;
  int? _lastReadSurahIndex;
  double? _lastReadScrollOffset;
  int? _lastReadAyahNum;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
    _loadLastRead();
  }

  void _loadSurahs() {
    final List<SurahInfo> surahs = QuranService.getAllSurahs();
    _allSurahs = surahs.map<Map<String, dynamic>>((s) {
      return {
        'index': s.index,
        'name': s.name,
        'verseCount': s.verseCount,
        'type': s.type,
      };
    }).toList();
    _filteredSurahs = _allSurahs;
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastReadSurahIndex = prefs.getInt('quranLastReadSurahIndex');
      _lastReadSurahName = prefs.getString('quranLastReadSurahName');
      _lastReadScrollOffset = prefs.getDouble('quranLastReadScrollOffset');
      _lastReadAyahNum = prefs.getInt('quranLastReadAyahNum');
    });
  }

  void _goToLastRead() {
    if (_lastReadSurahIndex == null) return;
    
    final surah = _allSurahs.firstWhere(
      (s) => s['index'] == _lastReadSurahIndex,
      orElse: () => _allSurahs.first,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuranReaderScreen(
          surahNumber: _lastReadSurahIndex!,
          surahName: surah['name'],
          surahType: surah['type'],
          initialScrollOffset: _lastReadScrollOffset ?? 0.0,
        ),
      ),
    ).then((_) => _loadLastRead());
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        final q = query.trim();
        _filteredSurahs = _allSurahs.where((s) {
          final String name = s['name'].toString();
          final String index = s['index'].toString();
          return name.contains(q) || index.contains(q);
        }).toList();
      }
    });
  }

  Future<void> _deleteLastReadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quranLastReadSurahIndex');
    await prefs.remove('quranLastReadSurahName');
    await prefs.remove('quranLastReadScrollOffset');
    await prefs.remove('quranLastReadAyahNum');
    setState(() {
      _lastReadSurahIndex = null;
      _lastReadSurahName = null;
      _lastReadScrollOffset = null;
      _lastReadAyahNum = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم مسح موضع القراءة بنجاح.',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  Widget _buildLastReadCard(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: _goToLastRead,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B4C35), Color(0xFF166E4F)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0B4C35).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.6),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFFD4AF37),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bookmark,
                          color: Color(0xFFD4AF37),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'متابعة القراءة (آخر موضع)',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'سورة $_lastReadSurahName ${_lastReadAyahNum != null ? '• الآية $_lastReadAyahNum' : ''}',
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white60,
                  size: 18,
                ),
                onPressed: _deleteLastReadBookmark,
                tooltip: 'إزالة العلامة',
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFD4AF37),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المصحف المكتوب',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF0B4C35),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Last Read Card
          if (_lastReadSurahName != null) _buildLastReadCard(isDark),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF103A2B) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSurahs,
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF06261b),
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن سورة بالاسم أو الرقم...',
                  hintStyle: GoogleFonts.cairo(
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _filterSurahs('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          
          // Surahs List
          Expanded(
            child: _filteredSurahs.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'لا توجد نتائج بحث مطابقة',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          color: isDark ? Colors.white70 : const Color(0xFF0B4C35),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredSurahs.length,
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 85),
                    itemBuilder: (context, index) {
                      final surah = _filteredSurahs[index];
                      final int surahIndex = surah['index'];
                      final String surahName = surah['name'];
                      final int verseCount = surah['verseCount'];
                      final String surahType = surah['type'];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isDark ? const Color(0xFF103A2B) : Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF0B4C35).withOpacity(0.1),
                            child: Text(
                              surahIndex.toString(),
                              style: GoogleFonts.cairo(
                                color: const Color(0xFFD4AF37),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(
                            'سورة $surahName',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? Colors.white : const Color(0xFF0B4C35),
                            ),
                          ),
                          subtitle: Text(
                            '$surahType • $verseCount آية',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : const Color(0xFF5A7A6E),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFFD4AF37),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuranReaderScreen(
                                  surahNumber: surahIndex,
                                  surahName: surahName,
                                  surahType: surahType,
                                ),
                              ),
                            ).then((_) => _loadLastRead());
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
