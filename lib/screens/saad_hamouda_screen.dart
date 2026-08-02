import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Services
import '../services/airtable_service.dart';
import '../services/audio_handler.dart';

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
  String? _activeCategory; // null, 'saad_nahw', 'saad_videos_YouTube', 'saad_5otab'
  String _categoryTitle = '';
  List<Map<String, dynamic>>? _items;
  bool _isLoading = false;
  String _searchQuery = '';

  Future<void> _loadCategory(String tableName, String title) async {
    setState(() {
      _isLoading = true;
      _activeCategory = tableName;
      _categoryTitle = title;
      _searchQuery = '';
    });

    try {
      final data = await AirtableService.fetchCustomTable(tableName);
      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading Saad category: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _activeCategory == null ? 'د. سعد حمودة - الدروس والخطب' : _categoryTitle,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: _activeCategory != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _activeCategory = null;
                    _items = null;
                    _searchQuery = '';
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

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _activeCategory == null
                ? _buildCategoriesGrid()
                : _buildItemsList(),
          ),

          // Persistent Mini Player
          const Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: MiniPlayerWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return ListView(
      children: [
        const SizedBox(height: 12),
        _buildCategoryCard(
          'دروس النحو',
          'شرح كتاب قواعد اللغة العربية والنحو بالتفصيل',
          Icons.menu_book,
          () => _loadCategory('saad_nahw', 'دروس النحو'),
        ),
        _buildCategoryCard(
          'فيديوهات متنوعة',
          'فيديوهات ودروس يوتيوب دينية وفتاوى علمية',
          Icons.play_circle_outline,
          () => _loadCategory('saad_videos_YouTube', 'فيديوهات متنوعة'),
        ),
        _buildCategoryCard(
          'خطب صوتية',
          'خطب الجمعة والمحاضرات الصوتية بصوت الشيخ',
          Icons.mic_none,
          () => _loadCategory('saad_5otab', 'خطب صوتية'),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
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
              backgroundColor: const Color(0xFFD4AF37).withOpacity(0.1),
              child: Icon(icon, color: const Color(0xFFD4AF37), size: 28),
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
            Icon(Icons.arrow_forward_ios, color: isDark ? Colors.white30 : const Color(0xFF0B4C35).withOpacity(0.4), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
        ),
      );
    }

    final filteredItems = _items == null
        ? <Map<String, dynamic>>[]
        : _items!.where((item) {
            final title = (item['title'] ?? '').toString().toLowerCase();
            return title.contains(_searchQuery.toLowerCase());
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: TextField(
            style: GoogleFonts.cairo(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              icon: const Icon(Icons.search, color: Colors.white30, size: 22),
              hintText: 'ابحث في هذا القسم...',
              hintStyle: GoogleFonts.cairo(color: Colors.white30, fontSize: 13),
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

        // List View
        Expanded(
          child: filteredItems.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد عناصر مطابقة للبحث.',
                    style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80), // spacer for mini player
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final String title = item['title'] ?? '';
                    final bool isVideo = _activeCategory != 'saad_5otab';
                    final bool isDark = Theme.of(context).brightness == Brightness.dark;

                    return Card(
                      color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFFD4AF37).withOpacity(0.1),
                          child: Icon(
                            isVideo ? Icons.play_arrow : Icons.audiotrack,
                            color: const Color(0xFFD4AF37),
                            size: 16,
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
                          isVideo ? Icons.play_circle_outline : Icons.play_circle_fill,
                          color: const Color(0xFFD4AF37),
                          size: 24,
                        ),
                        onTap: () {
                          if (isVideo) {
                            final String videoId = item['video'] ?? '';
                            if (videoId.isNotEmpty) {
                              // Pause any currently playing app audio before launching Youtube video
                              Provider.of<AudioProvider>(context, listen: false).pause();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YoutubePlayerScreen(
                                    videoId: videoId,
                                    title: title,
                                  ),
                                ),
                              );
                            }
                          } else {
                            // Play audio sermon
                            final String rawUrl = item['link'] ?? '';
                            final String streamUrl = rawUrl.replaceAll(
                              RegExp(r'https?://ia\d+\.us\.archive\.org/\d+/items/', caseSensitive: false),
                              'https://archive.org/download/'
                            );

                            Provider.of<AudioProvider>(context, listen: false).play(
                              streamUrl,
                              title,
                              'د. سعد حمودة',
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
        )
      ],
    );
  }
}
