import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Services
import '../services/audio_handler.dart';
import '../services/airtable_service.dart';

// Screens
import 'home_screen.dart'; // For MiniPlayerWidget
import 'audio_player_screen.dart';

class RecitersScreen extends StatefulWidget {
  const RecitersScreen({super.key});

  @override
  State<RecitersScreen> createState() => _RecitersScreenState();
}

class _RecitersScreenState extends State<RecitersScreen> {
  String _activeCategory = 'hawamdya';

  // Data Structures
  final Map<String, List<Map<String, String>>> _recitersData = {
    'hawamdya': [
      { 'id': 'h1', 'name': 'الشيخ حمدي أبو الدهب', 'avatar': 'images/Hdahab.jpg', 'server': 'mock' },
      { 'id': 'h2', 'name': 'الشيخ محمود عبدالسلام', 'avatar': 'images/Msalam.jpg', 'server': 'mock' },
      { 'id': 'h3', 'name': 'الشيخ محمد حسني', 'avatar': 'images/Mhosny.jpg', 'server': 'mock' },
      { 'id': 'h4', 'name': 'الشيخ محمد جمعة', 'avatar': 'images/Mgomaa.jpg', 'server': 'mock' },
      { 'id': 'h5', 'name': 'الشيخ حنفي محمود', 'avatar': 'images/Mhanafy.jpg', 'server': 'mock' },
      { 'id': 'h6', 'name': 'الشيخ عبدالرحمن مصطفى', 'avatar': 'images/AbdoMostafa.jpg', 'server': 'mock' }
    ],
    'egypt': [
      { 'id': 'e1', 'name': 'محمد صديق المنشاوي - مرتل 🇪🇬', 'avatar': 'images/MMenshawy.jpg', 'server': 'https://server10.mp3quran.net/minsh/' },
      { 'id': 'e2', 'name': 'محمد الطبلاوي - مجود 🇪🇬', 'avatar': 'images/MTablawy.jpg', 'server': 'https://server12.mp3quran.net/tblwy_mjod/' },
      { 'id': 'e3', 'name': 'أحمد نعينع - مجود 🇪🇬', 'avatar': 'images/ANeana3.jpg', 'server': 'https://server11.mp3quran.net/na3na_mjod/' },
      { 'id': 'e4', 'name': 'عبدالله كامل - مرتل 🇪🇬', 'avatar': 'images/AKamel.jpg', 'server': 'https://server16.mp3quran.net/kamal/' },
      { 'id': 'e5', 'name': 'عبدالباسط عبدالصمد - مرتل 🇪🇬', 'avatar': 'images/Abdelbaset.jpg', 'server': 'https://server7.mp3quran.net/basit/' },
      { 'id': 'e6', 'name': 'عبدالباسط عبدالصمد - مجود 🇪🇬', 'avatar': 'images/Abdelbaset.jpg', 'server': 'https://server13.mp3quran.net/basit_mjod/' },
      { 'id': 'e7', 'name': 'محمود خليل الحصري - مرتل 🇪🇬', 'avatar': 'images/7osary.jpg', 'server': 'https://server13.mp3quran.net/husr/' },
      { 'id': 'e8', 'name': 'محمود خليل الحصري - مجود 🇪🇬', 'avatar': 'images/7osary.jpg', 'server': 'https://server12.mp3quran.net/husr_mjod/' },
      { 'id': 'e9', 'name': 'محمود علي البنا - مرتل 🇪🇬', 'avatar': 'images/MAlbana.jpg', 'server': 'https://server8.mp3quran.net/banna/' },
      { 'id': 'e10', 'name': 'أحمد محمد عامر - مرتل 🇪🇬', 'avatar': 'images/Ahmed-amer.png', 'server': 'https://server10.mp3quran.net/a_amer/' }
    ],
    'saudi': [
      { 'id': 's1', 'name': 'محمد علي الحذيفي - مرتل 🇸🇦', 'avatar': 'images/7ozify.jpg', 'server': 'https://server9.mp3quran.net/hudhaify/' },
      { 'id': 's2', 'name': 'أحمد العجمي - مرتل 🇸🇦', 'avatar': 'images/Agamy.jpg', 'server': 'https://server10.mp3quran.net/ajm/' },
      { 'id': 's3', 'name': 'سعد الغامدي - مرتل 🇸🇦', 'avatar': 'images/Saad_Ghamdy.jpg', 'server': 'https://server7.mp3quran.net/s_gmd/' },
      { 'id': 's4', 'name': 'سعود الشريم - مرتل 🇸🇦', 'avatar': 'images/ElShorem.jpg', 'server': 'https://server7.mp3quran.net/shur/' },
      { 'id': 's5', 'name': 'عبدالرحمن السديس - مرتل 🇸🇦', 'avatar': 'images/Sodes.jpg', 'server': 'https://server11.mp3quran.net/sds/' },
      { 'id': 's6', 'name': 'ماهر المعيقلي - مرتل 🇸🇦', 'avatar': 'images/Maher.png', 'server': 'https://server12.mp3quran.net/maher/' },
      { 'id': 's7', 'name': 'محمد أيوب - مرتل 🇸🇦', 'avatar': 'images/Ayob.jpeg', 'server': 'https://server8.mp3quran.net/ayoub/' },
      { 'id': 's8', 'name': 'ناصر القطامي - مرتل 🇸🇦', 'avatar': 'images/Katamy.jpg', 'server': 'https://server11.mp3quran.net/qtm/' },
      { 'id': 's9', 'name': 'ياسر الدوسري - مرتل 🇸🇦', 'avatar': 'images/Dosary.jpg', 'server': 'https://server11.mp3quran.net/yasser/' }
    ]
  };

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

  final List<Map<String, String>> _surahList = List.generate(114, (index) {
    final num = (index + 1).toString().padLeft(3, '0');
    return {
      'num': num,
      'name': 'سورة ${_surahNames[index]}',
    };
  });

  final List<Map<String, String>> _lecturesList = [
    { 'num': '001', 'name': 'خطبة الجمعة: التقوى والعمل الصالح' },
    { 'num': '002', 'name': 'خطبة الجمعة: تربية الأبناء في الإسلام' },
    { 'num': '003', 'name': 'خطبة الجمعة: أخلاق المسلم' },
    { 'num': '004', 'name': 'درس النحو: شرح المقدمة الآجرومية (الباب الأول)' },
    { 'num': '005', 'name': 'درس النحو: علامات الإعراب الأصلية والفرعية' },
    { 'num': '006', 'name': 'درس النحو: النواسخ (كان وأخواتها)' }
  ];

  @override
  Widget build(BuildContext context) {
    final reciters = _recitersData[_activeCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('القراء', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0B4C35),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background
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
          Column(
            children: [
              const SizedBox(height: 12),
              
              // Custom Horizontal Tab Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildTabButton('hawamdya', 'قراء الحوامدية'),
                    const SizedBox(width: 8),
                    _buildTabButton('egypt', 'قراء مصر 🇪🇬'),
                    const SizedBox(width: 8),
                    _buildTabButton('saudi', 'السعودية 🇸🇦'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Reciters Grid View
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 85.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: reciters.length,
                  itemBuilder: (context, index) {
                    final reciter = reciters[index];
                    return GestureDetector(
                      onTap: () => _showSurahSelector(reciter),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.04) : Colors.white,
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: reciter['avatar']!.startsWith('http')
                                  ? NetworkImage(reciter['avatar']!) as ImageProvider
                                  : AssetImage(reciter['avatar']!) as ImageProvider,
                              backgroundColor: const Color(0xFF0B4C35),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                reciter['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0B4C35),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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

  Widget _buildTabButton(String category, String label) {
    final bool isActive = _activeCategory == category;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
              ? (isDark ? const Color(0xFF166E4F) : const Color(0xFF0B4C35)) 
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive 
                ? (isDark ? const Color(0xFF166E4F) : const Color(0xFF0B4C35)) 
                : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06)),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: (isDark ? const Color(0xFF166E4F) : const Color(0xFF0B4C35)).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive 
                ? Colors.white 
                : (isDark ? const Color(0xFFA3C8BC) : const Color(0xFF5A7A6E)),
          ),
        ),
      ),
    );
  }

  void _showSurahSelector(Map<String, String> reciter) {
    if (reciter['id'] == 'l1') {
      _showSaadHamoudaSheet(reciter);
      return;
    }

    final itemsList = _surahList;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF093B2A)
          : const Color(0xFFF4F7F5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bottomsheet Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reciter['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF0B4C35),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: isDark ? Colors.white : const Color(0xFF0B4C35)),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              Divider(color: isDark ? Colors.white10 : Colors.black12),
              
              // Track lists
              Expanded(
                child: ListView.builder(
                  itemCount: itemsList.length,
                  itemBuilder: (context, index) {
                    final item = itemsList[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(0xFFD4AF37).withOpacity(0.1),
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF072A1E),
                        ),
                      ),
                      trailing: const Icon(Icons.play_circle_fill, color: Color(0xFFD4AF37), size: 24),
                      onTap: () {
                        // Dismiss bottom sheet
                        Navigator.pop(context);
                        
                        // Generate audio stream URL
                        String streamUrl = '';
                        final String? airtableUrl = AirtableService.getAudioUrl(reciter['id']!, item['num']!);
                        if (airtableUrl != null && airtableUrl.isNotEmpty) {
                          streamUrl = airtableUrl;
                        } else {
                          if (reciter['server'] == 'mock') {
                            streamUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
                          } else {
                            streamUrl = '${reciter['server']}${item['num']}.mp3';
                          }
                        }

                        // Play audio via provider
                        Provider.of<AudioProvider>(context, listen: false).play(
                          streamUrl,
                          item['name']!,
                          reciter['name']!,
                        );

                        // Route directly to Full Audio Player screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AudioPlayerScreen()),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showSaadHamoudaSheet(Map<String, String> reciter) {
    String? activeTab; // 'nahw', 'videos', '5otab'
    String activeTitle = '';
    List<Map<String, dynamic>>? items;
    bool isLoading = false;
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF093B2A)
          : const Color(0xFFF4F7F5),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      if (activeTab != null)
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : const Color(0xFF0B4C35), size: 20),
                          onPressed: () {
                            setSheetState(() {
                              activeTab = null;
                              items = null;
                              searchQuery = '';
                            });
                          },
                        ),
                      Expanded(
                        child: Text(
                          activeTab == null ? reciter['name']! : activeTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const Divider(color: Colors.white10),
                  
                  // Category Grid Selection View
                  if (activeTab == null)
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(height: 12),
                          _buildCategoryCard(
                            context,
                            'دروس النحو',
                            'شرح كتاب قواعد اللغة العربية والنحو بالتفصيل',
                            Icons.menu_book,
                            () async {
                              setSheetState(() {
                                activeTab = 'nahw';
                                activeTitle = 'دروس النحو';
                                isLoading = true;
                              });
                              final data = await AirtableService.fetchCustomTable('saad_nahw');
                              setSheetState(() {
                                items = data;
                                isLoading = false;
                              });
                            },
                          ),
                          _buildCategoryCard(
                            context,
                            'فيديوهات متنوعة',
                            'فيديوهات ودروس يوتيوب دينية وفتاوى علمية',
                            Icons.play_circle_outline,
                            () async {
                              setSheetState(() {
                                activeTab = 'videos';
                                activeTitle = 'فيديوهات متنوعة';
                                isLoading = true;
                              });
                              final data = await AirtableService.fetchCustomTable('saad_videos_YouTube');
                              setSheetState(() {
                                items = data;
                                isLoading = false;
                              });
                            },
                          ),
                          _buildCategoryCard(
                            context,
                            'خطب صوتية',
                            'خطب الجمعة والمحاضرات الصوتية بصوت الشيخ',
                            Icons.mic_none,
                            () async {
                              setSheetState(() {
                                activeTab = '5otab';
                                activeTitle = 'خطب صوتية';
                                isLoading = true;
                              });
                              final data = await AirtableService.fetchCustomTable('saad_5otab');
                              setSheetState(() {
                                items = data;
                                isLoading = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                  // Loaded Items List View
                  if (activeTab != null) ...[
                    if (isLoading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                          ),
                        ),
                      )
                    else ...[
                      // Search inside category
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
                          ),
                          boxShadow: isDark
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                        ),
                        child: TextField(
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF0B4C35),
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.search,
                              color: isDark ? Colors.white30 : const Color(0xFF5A7A6E),
                              size: 20,
                            ),
                            hintText: 'ابحث في هذا القسم...',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white30 : const Color(0xFF8A9A93),
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setSheetState(() {
                              searchQuery = val;
                            });
                          },
                        ),
                      ),
                      
                      // List View
                      Expanded(
                        child: ListView.builder(
                          itemCount: items == null
                              ? 0
                              : items!.where((item) {
                                  final title = (item['title'] ?? '').toString().toLowerCase();
                                  return title.contains(searchQuery.toLowerCase());
                                }).length,
                          itemBuilder: (context, index) {
                            final filteredItems = items!.where((item) {
                              final title = (item['title'] ?? '').toString().toLowerCase();
                              return title.contains(searchQuery.toLowerCase());
                            }).toList();
                            
                            final item = filteredItems[index];
                            final String title = item['title'] ?? '';
                            final bool isVideo = activeTab != '5otab';
                            
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : const Color(0xFF072A1E),
                                ),
                              ),
                              trailing: Icon(
                                isVideo ? Icons.open_in_new : Icons.play_circle_fill,
                                color: const Color(0xFFD4AF37),
                                size: 22,
                              ),
                              onTap: () async {
                                if (isVideo) {
                                  final String videoId = item['video'] ?? '';
                                  if (videoId.isNotEmpty) {
                                    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  }
                                } else {
                                  // Play Audio sermon
                                  final String rawUrl = item['link'] ?? '';
                                  final String streamUrl = rawUrl.replaceAll(
                                    RegExp(r'https?://ia\d+\.us\.archive\.org/\d+/items/', caseSensitive: false),
                                    'https://archive.org/download/'
                                  );
                                  
                                  Navigator.pop(context); // Close sheet
                                  
                                  Provider.of<AudioProvider>(context, listen: false).play(
                                    streamUrl,
                                    title,
                                    reciter['name']!,
                                  );
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AudioPlayerScreen()),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ]
                  ]
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFD4AF37).withOpacity(0.1),
              child: Icon(icon, color: const Color(0xFFD4AF37), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }
}
