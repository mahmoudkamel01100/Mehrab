import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Services
import '../services/firebase_rtdb_service.dart';
import '../services/audio_handler.dart';
import '../services/network_helper.dart';

// Screens
import 'youtube_player_screen.dart';
import 'audio_player_screen.dart';
import 'home_screen.dart'; // For MiniPlayerWidget

class SaadHamoudaScreen extends StatefulWidget {
  const SaadHamoudaScreen({super.key});

  @override
  State<SaadHamoudaScreen> createState() => _SaadHamoudaScreenState();
}

class _SaadHamoudaScreenState extends State<SaadHamoudaScreen> {
  // Navigation State
  String? _selectedSheikh; // null (Sheikhs list), or Sheikh Name
  String? _selectedType; // 'audio' or 'video'
  
  List<Map<String, dynamic>> _allLectures = [];
  bool _isLoading = false;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _sheikhs = [
    {
      'name': 'د. سعد حمودة',
      'title': 'د. سعد حمودة',
      'subtitle': 'خطب الجمعة والمحاضرات والدروس العلمية',
      'icon': Icons.school_outlined,
      'color': const Color(0xFFD4AF37),
    },
    {
      'name': 'الشيخ عبدالله عبدالتواب',
      'title': 'الشيخ عبدالله عبدالتواب',
      'subtitle': 'خطب الجمعة والدروس الإيمانية',
      'icon': Icons.mic_none,
      'color': const Color(0xFF166E4F),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchLectures();
  }

  Future<void> _fetchLectures() async {
    setState(() {
      _isLoading = true;
    });

    final isOnline = await NetworkHelper.isConnected();
    if (!isOnline && mounted) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final data = await FirebaseRtdbService.fetchAllLectures();
    if (mounted) {
      setState(() {
        _allLectures = data;
        _isLoading = false;
      });
    }
  }

  String _cleanUrl(String url) {
    return url.replaceAll(
      RegExp(r'https?://ia\d+\.us\.archive\.org/\d+/items/', caseSensitive: false),
      'https://archive.org/download/',
    );
  }

  bool _matchesSheikh(String sheikhFromDb, String targetSheikh) {
    final normalize = (String s) => s
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('.', '')
        .replaceAll(' ', '')
        .trim();
    return normalize(sheikhFromDb).contains(normalize(targetSheikh)) ||
           normalize(targetSheikh).contains(normalize(sheikhFromDb));
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = 'دروس وخطب';
    if (_selectedSheikh != null) {
      if (_selectedType != null) {
        appTitle = _selectedType == 'audio'
            ? 'خطب صوتية - $_selectedSheikh'
            : 'خطب مرئية - $_selectedSheikh';
      } else {
        appTitle = _selectedSheikh!;
      }
    }

    return PopScope(
      canPop: _selectedSheikh == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            if (_selectedType != null) {
              _selectedType = null;
              _searchQuery = '';
            } else if (_selectedSheikh != null) {
              _selectedSheikh = null;
              _searchQuery = '';
            }
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appTitle,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          leading: _selectedSheikh != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (_selectedType != null) {
                        _selectedType = null;
                        _searchQuery = '';
                      } else {
                        _selectedSheikh = null;
                        _searchQuery = '';
                      }
                    });
                  },
                )
              : null,
          backgroundColor: const Color(0xFF0B4C35),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? const [Color(0xFF0E5C41), Color(0xFF051E15)]
                      : const [Color(0xFFEBF2EE), Color(0xFFD6E2DB)],
                  radius: 1.2,
                ),
              ),
            ),

            // Main Content Area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCurrentView(),
            ),

            // Persistent Mini Player
            const Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: MiniPlayerWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    if (_selectedSheikh == null) {
      return _buildSheikhsList();
    } else if (_selectedType == null) {
      return _buildTypeSelection();
    } else {
      return _buildItemsList();
    }
  }

  // View 1: List of Sheikhs (Clean & Simple: Name only)
  Widget _buildSheikhsList() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 85.0),
      children: [
        const SizedBox(height: 8),
        ..._sheikhs.map((sheikh) {
          final String name = sheikh['name'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  final isOnline = await NetworkHelper.isConnected();
                  if (!isOnline && mounted) {
                    NetworkHelper.showNoInternetDialog(
                      context,
                      title: 'الدروس والخطب تتطلب إنترنت',
                      message: 'يتطلب تصفح الخطب والدروس وجود اتصال نشط بالإنترنت لتحميل المحتوى. يرجى التأكد من اتصال الهاتف بالإنترنت والمحاولة مجدداً.',
                    );
                    return;
                  }

                  setState(() {
                    _selectedSheikh = name;
                    _selectedType = null;
                    _searchQuery = '';
                  });

                  if (_allLectures.isEmpty) {
                    _fetchLectures();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : const Color(0xFF0B4C35),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark ? Colors.white30 : const Color(0xFF0B4C35).withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // View 2: Audio vs Video Selection for selected Sheikh
  Widget _buildTypeSelection() {
    return ListView(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 85.0),
      children: [
        const SizedBox(height: 8),
        _buildSheikhCard(
          'الخطب الصوتية',
          'استمع إلى خطب ومحاضرات $_selectedSheikh بصوت نقي',
          Icons.audiotrack,
          const Color(0xFFD4AF37),
          () {
            setState(() {
              _selectedType = 'audio';
              _searchQuery = '';
            });
          },
        ),
        _buildSheikhCard(
          'الخطب والمرئيات (فيديو)',
          'شاهد خطب ودروس $_selectedSheikh على اليوتيوب',
          Icons.play_circle_outline,
          Colors.red.shade700,
          () {
            setState(() {
              _selectedType = 'video';
              _searchQuery = '';
            });
          },
        ),
      ],
    );
  }

  // View 3: Items list (Filtered by Sheikh and Type)
  Widget _buildItemsList() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
        ),
      );
    }

    final filteredItems = _allLectures.where((item) {
      final sheikh = (item['shekh'] ?? item['sheikh'] ?? '').toString();
      final type = (item['Type'] ?? item['type'] ?? '').toString().toLowerCase();
      final title = (item['title'] ?? '').toString();

      final matchesSheikh = _matchesSheikh(sheikh, _selectedSheikh!);
      final matchesType = type == _selectedType;
      final matchesSearch = _searchQuery.isEmpty || title.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesSheikh && matchesType && matchesSearch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          child: TextField(
            style: GoogleFonts.cairo(
              color: isDark ? Colors.white : const Color(0xFF0B4C35),
              fontSize: 13,
            ),
            decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: isDark ? Colors.white30 : const Color(0xFF5A7A6E),
                size: 22,
              ),
              hintText: 'ابحث في هذا القسم...',
              hintStyle: GoogleFonts.cairo(
                color: isDark ? Colors.white30 : const Color(0xFF8A9A93),
                fontSize: 13,
              ),
              border: InputBorder.none,
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),
        const SizedBox(height: 16),

        // List of items
        Expanded(
          child: filteredItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedType == 'audio' ? Icons.audiotrack : Icons.videocam_off_outlined,
                        size: 48,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'لا توجد عناصر متاحة حالياً.',
                        style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 85),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final String title = item['title'] ?? 'بدون عنوان';
                    final String rawLink = (item['link'] ?? '').toString();
                    final bool isVideo = _selectedType == 'video';

                    return Card(
                      color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: (isVideo ? Colors.red : const Color(0xFFD4AF37)).withOpacity(0.12),
                          child: Icon(
                            isVideo ? Icons.play_arrow : Icons.audiotrack,
                            color: isVideo ? Colors.red.shade700 : const Color(0xFFD4AF37),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          title,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF0B4C35),
                          ),
                        ),
                        trailing: Icon(
                          isVideo ? Icons.open_in_new : Icons.play_circle_fill,
                          color: isVideo ? Colors.red.shade700 : const Color(0xFFD4AF37),
                          size: 24,
                        ),
                        onTap: () async {
                          final isOnline = await NetworkHelper.isConnected();
                          if (!isOnline && context.mounted) {
                            NetworkHelper.showNoInternetDialog(
                              context,
                              title: 'التشغيل يتطلب إنترنت',
                              message: 'يتطلب تشغيل الخطب والصوتيات وجود اتصال نشط بالإنترنت.',
                            );
                            return;
                          }

                          if (isVideo) {
                            // In-app Video playback
                            try {
                              Provider.of<AudioProvider>(context, listen: false).pause();
                            } catch (_) {}

                            String videoId = rawLink.trim();
                            final regExp = RegExp(r'(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})');
                            final match = regExp.firstMatch(videoId);
                            if (match != null && match.groupCount >= 1) {
                              videoId = match.group(1)!;
                            } else if (videoId.contains('?')) {
                              videoId = videoId.split('?')[0];
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => YoutubePlayerScreen(
                                  videoId: videoId,
                                  title: title,
                                ),
                              ),
                            );
                          } else {
                            // Audio playback
                            final streamUrl = _cleanUrl(rawLink);
                            Provider.of<AudioProvider>(context, listen: false).play(
                              streamUrl,
                              title,
                              _selectedSheikh!,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AudioPlayerScreen()),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSheikhCard(
      String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04),
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF0B4C35),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: isDark ? const Color(0xFFA3C8BC) : const Color(0xFF5A7A6E),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.white30 : const Color(0xFF0B4C35).withOpacity(0.4),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
