import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/quran_service.dart';

class QuranReaderScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String surahType;
  final double initialScrollOffset;

  const QuranReaderScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.surahType,
    this.initialScrollOffset = 0.0,
  });

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  bool _isScrolling = false;
  double _scrollSpeed = 3.0;
  double _fontSize = 24.0;
  bool _isBookmarked = false;
  bool _isExplicitlyUnsaved = false;
  Timer? _saveDebounce;

  List<String> _versesList = [];
  String? _diagnosticsError;
  int _totalVersesCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadVersesData();
    _checkBookmarkStatus();
    _loadFontSize();

    _scrollController.addListener(_handleScroll);
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _fontSize = prefs.getDouble('quran_font_size') ?? 24.0;
      });
    }
  }

  Future<void> _saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('quran_font_size', size);
    if (mounted) {
      setState(() {
        _fontSize = size;
      });
    }
  }

  void _loadVersesData() {
    try {
      _versesList = QuranService.getSurahVerses(widget.surahNumber);
      _totalVersesCount = _versesList.length;
      if (_versesList.isEmpty) {
        _diagnosticsError = "قائمة الآيات فارغة (count = 0)";
      }
    } catch (e, stack) {
      _diagnosticsError = "Exception: $e\n\nStack:\n$stack";
    }
  }

  void _showDiagnosticsPopup() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF093B2A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.bug_report, color: Color(0xFFD4AF37), size: 28),
            const SizedBox(width: 8),
            Text(
              'تقرير تشخيص شاشة القرآن',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFFD4AF37)),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• رقم السورة: ${widget.surahNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('• اسم السورة: ${widget.surahName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('• عدد الآيات المحسوب: $_totalVersesCount'),
              Text('• حجم مصفوفة الآيات: ${_versesList.length}'),
              const Divider(color: Colors.grey),
              const Text('تفاصيل الحالة:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _diagnosticsError ?? "الآيات تم جلبها بنجاح في الذاكرة: ${_versesList.length} آية.",
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveBookmarkSilent();
    }
  }

  void _handleScroll() {
    if (_isExplicitlyUnsaved) return;
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), () {
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
    final int count = _versesList.isNotEmpty ? _versesList.length : 1;
    final int estimated = (ratio * count).round().clamp(1, count);
    return estimated;
  }

  Future<void> _checkBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('quranLastReadSurahIndex');
    if (mounted) {
      setState(() {
        _isBookmarked = savedIndex == widget.surahNumber;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
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
              'تم إزالة علامة القراءة سورة ${widget.surahName}',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    } else {
      await prefs.setInt('quranLastReadSurahIndex', widget.surahNumber);
      await prefs.setString('quranLastReadSurahName', widget.surahName);
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
              'تم حفظ علامة موضع القراءة بنجاح في سورة ${widget.surahName} - الآية $ayahNum',
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
    final int ayahNum = _getEstimateAyahNum();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quranLastReadSurahIndex', widget.surahNumber);
    await prefs.setString('quranLastReadSurahName', widget.surahName);
    await prefs.setDouble('quranLastReadScrollOffset', offset);
    await prefs.setInt('quranLastReadAyahNum', ayahNum);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

    _scrollTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!_scrollController.hasClients) return;
      
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double currentScroll = _scrollController.position.pixels;
      
      if (currentScroll >= maxScroll - 1.0) {
        _stopAutoScroll();
      } else {
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
      _startAutoScroll();
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF093B2A) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'حجم خط المصحف',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFFD4AF37)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFD4AF37), size: 28),
                    onPressed: () {
                      if (_fontSize > 16) {
                        final newSize = _fontSize - 2;
                        _saveFontSize(newSize);
                        setSheetState(() {});
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_fontSize.toInt()} px',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD4AF37), size: 28),
                    onPressed: () {
                      if (_fontSize < 40) {
                        final newSize = _fontSize + 2;
                        _saveFontSize(newSize);
                        setSheetState(() {});
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: _fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool showBasmala = widget.surahNumber != 1 && widget.surahNumber != 9;
    
    final int totalListItems = (showBasmala ? 1 : 0) + _versesList.length + 1;

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
            'سورة ${widget.surahName} (${widget.surahType} • ${_versesList.length} آية)',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF0B4C35),
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.format_size, color: Colors.white),
              onPressed: _showFontSizeDialog,
              tooltip: 'تغيير حجم الخط',
            ),
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
          color: isDark ? const Color(0xFF072A1E) : const Color(0xFFF8F9FA),
          child: _versesList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFD4AF37), size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'تعذر عرض آيات سورة ${widget.surahName}',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0B4C35),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _showDiagnosticsPopup,
                          icon: const Icon(Icons.info_outline),
                          label: const Text('تقرير الفحص'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: const Color(0xFF072A1E),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  itemCount: totalListItems,
                  itemBuilder: (context, index) {
                    // 1. Basmala Header (for surahs other than Fatiha and Tawbah)
                    if (showBasmala && index == 0) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0, top: 4.0),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF103A2B).withOpacity(0.5) : const Color(0xFFD4AF37).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                        ),
                        child: Text(
                          QuranService.basmala,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: _fontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                      );
                    }

                    // Calculate verse array index
                    final int verseArrayIndex = showBasmala ? index - 1 : index;

                    // 2. Bottom Spacing Item
                    if (verseArrayIndex >= _versesList.length) {
                      return const SizedBox(height: 80);
                    }

                    final String verseText = _versesList[verseArrayIndex];
                    final int verseNumber = verseArrayIndex + 1;

                    // 3. Verse Card Item
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF103A2B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            verseText,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: _fontSize,
                              height: 2.1,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF0B4C35),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFD4AF37).withOpacity(0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '﴿ $verseNumber ﴾',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD4AF37),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        
        // Bottom control bar
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF103A2B) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: const Color(0xFFD4AF37).withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    elevation: 2,
                  ),
                ),
                
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward, color: Color(0xFFD4AF37), size: 22),
                      tooltip: 'العودة للبداية',
                      onPressed: _scrollToTop,
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.speed,
                      size: 20,
                      color: Color(0xFFD4AF37),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 90,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
