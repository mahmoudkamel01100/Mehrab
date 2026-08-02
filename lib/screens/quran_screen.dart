import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quran_reader_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final List<String> _surahTypes = const [
    "مكية", "مدنية", "مدنية", "مدنية", "مدنية", "مكية", "مكية", "مدنية", "مدنية", "مكية",
    "مكية", "مكية", "مدنية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مدنية", "مكية", "مدنية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مدنية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مدنية", "مدنية", "مدنية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مدنية", "مكية", "مدنية", "مدنية", "مدنية", "مدنية",
    "مدنية", "مدنية", "مدنية", "مدنية", "مدنية", "مدنية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مدنية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مدنية", "مدنية", "مكية",
    "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مكية", "مدنية",
    "مكية", "مكية", "مكية", "مكية"
  ];

  List<dynamic> _allSurahs = [];
  List<dynamic> _filteredSurahs = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  String? _lastReadSurahName;
  int? _lastReadSurahIndex;
  double? _lastReadScrollOffset;
  int? _lastReadAyahNum;

  @override
  void initState() {
    super.initState();
    _loadQuranText();
    _loadLastRead();
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
    
    // Find the saved surah map
    final surah = _allSurahs.firstWhere(
      (s) => s['index'] == _lastReadSurahIndex,
      orElse: () => null,
    );
    if (surah == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuranReaderScreen(
          surah: surah,
          type: _surahTypes[_lastReadSurahIndex! - 1],
          initialScrollOffset: _lastReadScrollOffset ?? 0.0,
        ),
      ),
    ).then((_) => _loadLastRead()); // Reload when returning to refresh card
  }

  Future<void> _loadQuranText() async {
    try {
      final String jsonStr = await DefaultAssetBundle.of(context).loadString('images/quran_text.json');
      final List<dynamic> data = json.decode(jsonStr);
      setState(() {
        _allSurahs = data;
        _filteredSurahs = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Quran text: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        _filteredSurahs = _allSurahs.where((surah) {
          final String name = surah['name'] ?? '';
          return name.contains(query) || surah['index'].toString().contains(query);
        }).toList();
      }
    });
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
              ),
            )
          : Column(
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
                        hintText: 'ابحث عن سورة...',
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
                  child: ListView.builder(
                    itemCount: _filteredSurahs.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final surah = _filteredSurahs[index];
                      final int surahIndex = surah['index'];
                      final String surahName = surah['name'] ?? '';
                      final int ayahsCount = (surah['ayahs'] as List).length;

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
                            '${_surahTypes[surahIndex - 1]} • $ayahsCount آية',
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
                                  surah: surah,
                                  type: _surahTypes[surahIndex - 1],
                                ),
                              ),
                            );
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
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: _goToLastRead,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37).withOpacity(0.06),
                  const Color(0xFF0B4C35).withOpacity(0.06),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.bookmark, color: Color(0xFFD4AF37), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'متابعة القراءة',
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                      Text(
                        _lastReadAyahNum != null 
                            ? 'سورة $_lastReadSurahName - الآية $_lastReadAyahNum'
                            : 'سورة $_lastReadSurahName',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0B4C35),
                        ),
                      ),
                    ],
                  ),
                ),
                // Trash icon button to delete bookmark
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                  onPressed: () {
                    _deleteLastReadBookmark();
                  },
                  tooltip: 'مسح موضع القراءة',
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFFD4AF37),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
