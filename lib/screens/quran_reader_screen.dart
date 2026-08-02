import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranReaderScreen extends StatefulWidget {
  final Map<String, dynamic> surah;
  final String type;
  final double initialScrollOffset;

  const QuranReaderScreen({
    super.key,
    required this.surah,
    required this.type,
    this.initialScrollOffset = 0.0,
  });

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  bool _isScrolling = false;
  double _scrollSpeed = 3.0;
  bool _isBookmarked = false;
  bool _isExplicitlyUnsaved = false;

  Timer? _saveDebounce;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
    if (widget.initialScrollOffset > 0.0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(widget.initialScrollOffset);
        }
      });
    }
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_isExplicitlyUnsaved) return;
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isExplicitlyUnsaved) {
        _saveBookmarkSilent();
      }
    });
  }

  int _getEstimateAyahNum() {
    if (!_scrollController.hasClients) return 1;
    final double maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return 1;
    final double currentScroll = _scrollController.position.pixels;
    final double ratio = (currentScroll / maxScroll).clamp(0.0, 1.0);
    
    final List<dynamic> ayahs = widget.surah['ayahs'] ?? [];
    if (ayahs.isEmpty) return 1;
    
    int totalChars = 0;
    final List<int> cumulativeChars = [];
    for (var ayah in ayahs) {
      final String text = ayah['text'] ?? '';
      totalChars += text.length;
      cumulativeChars.add(totalChars);
    }
    
    if (totalChars == 0) return 1;
    
    final double targetCharOffset = totalChars * ratio;
    
    for (int i = 0; i < cumulativeChars.length; i++) {
      if (cumulativeChars[i] >= targetCharOffset) {
        return ayahs[i]['num'] ?? (i + 1);
      }
    }
    return ayahs.last['num'] ?? ayahs.length;
  }

  Future<void> _checkBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('quranLastReadSurahIndex');
    if (mounted) {
      setState(() {
        _isBookmarked = savedIndex == widget.surah['index'];
      });
    }
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final int surahIndex = widget.surah['index'];
    final String surahName = widget.surah['name'] ?? '';
    final int ayahNum = _getEstimateAyahNum();

    if (_isBookmarked) {
      await prefs.remove('quranLastReadSurahIndex');
      await prefs.remove('quranLastReadSurahName');
      await prefs.remove('quranLastReadScrollOffset');
      await prefs.remove('quranLastReadAyahNum');
      setState(() {
        _isBookmarked = false;
        _isExplicitlyUnsaved = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إزالة علامة القراءة سورة $surahName',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    } else {
      await prefs.setInt('quranLastReadSurahIndex', surahIndex);
      await prefs.setString('quranLastReadSurahName', surahName);
      await prefs.setDouble('quranLastReadScrollOffset', _scrollController.offset);
      await prefs.setInt('quranLastReadAyahNum', ayahNum);
      setState(() {
        _isBookmarked = true;
        _isExplicitlyUnsaved = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم حفظ علامة موضع القراءة بنجاح في سورة $surahName - الآية $ayahNum',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF0B4C35),
          ),
        );
      }
    }
  }

  Future<void> _saveBookmarkSilent() async {
    if (!_scrollController.hasClients || _isExplicitlyUnsaved) return;
    final double offset = _scrollController.offset;
    final int surahIndex = widget.surah['index'];
    final String surahName = widget.surah['name'] ?? '';
    final int ayahNum = _getEstimateAyahNum();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quranLastReadSurahIndex', surahIndex);
    await prefs.setString('quranLastReadSurahName', surahName);
    await prefs.setDouble('quranLastReadScrollOffset', offset);
    await prefs.setInt('quranLastReadAyahNum', ayahNum);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _scrollTimer?.cancel();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleAutoScroll() {
    if (_isScrolling) {
      _stopAutoScroll();
    } else {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _scrollTimer?.cancel();
    setState(() {
      _isScrolling = true;
    });

    // Scroll small increments frequently for butter-smooth visual flow
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!_scrollController.hasClients) return;
      
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double currentScroll = _scrollController.position.pixels;
      
      if (currentScroll >= maxScroll - 1.0) {
        _stopAutoScroll();
      } else {
        // Scroll down fractionally
        _scrollController.jumpTo(currentScroll + (_scrollSpeed * 0.12));
      }
    });
  }

  void _stopAutoScroll() {
    _scrollTimer?.cancel();
    if (mounted) {
      setState(() {
        _isScrolling = false;
      });
    }
  }

  void _updateSpeed(double newSpeed) {
    setState(() {
      _scrollSpeed = newSpeed;
    });
    if (_isScrolling) {
      _startAutoScroll(); // Restart timer with new speed immediately
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int surahIndex = widget.surah['index'];
    final String surahName = widget.surah['name'] ?? '';
    final List<dynamic> ayahs = widget.surah['ayahs'] ?? [];

    // Build the TextSpans flow
    final List<InlineSpan> spans = [];
    
    for (var i = 0; i < ayahs.length; i++) {
      final ayah = ayahs[i];
      String text = ayah['text'] ?? '';
      final int num = ayah['num'] ?? (i + 1);

      // Strip Basmala from the beginning of verse 1 for non-Fatiha surahs
      if (surahIndex != 1 && num == 1) {
        text = text.replaceFirst(RegExp(r'^بِسْمِ\s+اللَّهِ\s+الرَّحْمَٰنِ\s+الرَّحِيمِ\s*'), '');
        text = text.replaceFirst(RegExp(r'^بِسْمِ\s+اللهِ\s+الرَّحٰمنِ\s+الرَّحِيْمِ\s*'), '');
      }

      spans.add(
        TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: 24, // Increased from 20 to 24 for grand readability!
            height: 2.5,  // Spaced line-height
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white.withOpacity(0.95) : const Color(0xFF06261B),
          ),
        ),
      );

      // Ayah Number Badge
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.2),
              color: const Color(0xFFD4AF37).withOpacity(0.08),
            ),
            child: Text(
              num.toString(),
              style: GoogleFonts.cairo(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
              ),
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          _saveBookmarkSilent();
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(
          'سورة $surahName (${widget.type} • ${ayahs.length} آية)',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        backgroundColor: const Color(0xFF0B4C35),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: const Color(0xFFD4AF37),
            ),
            onPressed: _toggleBookmark,
            tooltip: 'حفظ علامة القراءة',
          ),
        ],
      ),
      body: Container(
        color: isDark ? const Color(0xFF072A1E) : const Color(0xFFF4F7F5),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Show Basmala centered at the top (except Surah Al-Tawbah)
              if (surahIndex != 9) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              
              // Flowing Quran Verses Text
              Directionality(
                textDirection: TextDirection.rtl,
                child: RichText(
                  textAlign: TextAlign.center, // Centered text flow
                  text: TextSpan(
                    children: spans,
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      
      // Auto Scroll bottom control bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF103A2B) : Colors.white,
          border: Border(
            top: BorderSide(
              color: const Color(0xFFD4AF37).withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Auto scroll action button
              ElevatedButton.icon(
                onPressed: _toggleAutoScroll,
                icon: Icon(
                  _isScrolling ? Icons.pause : Icons.play_arrow,
                  size: 18,
                  color: _isScrolling ? Colors.white : const Color(0xFF06261B),
                ),
                label: Text(
                  _isScrolling ? 'إيقاف التمرير' : 'تمرير تلقائي',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: _isScrolling ? Colors.white : const Color(0xFF06261B),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isScrolling 
                      ? Colors.red.shade700 
                      : const Color(0xFFD4AF37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                ),
              ),
              
              // Speed slider controller
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.speed,
                      size: 20,
                      color: Color(0xFFD4AF37),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: Slider(
                        value: _scrollSpeed,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        activeColor: const Color(0xFFD4AF37),
                        inactiveColor: isDark 
                            ? const Color(0xFF0B4C35).withOpacity(0.3) 
                            : Colors.grey.shade300,
                        onChanged: _updateSpeed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
