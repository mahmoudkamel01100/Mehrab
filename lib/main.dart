import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/reciters_screen.dart';
import 'screens/azkar_screen.dart';
import 'screens/tasbih_screen.dart';
import 'screens/quran_screen.dart';
import 'screens/saad_hamouda_screen.dart';

// Providers / State Management
import 'services/audio_handler.dart';
import 'services/theme_provider.dart';
import 'services/airtable_service.dart';
import 'services/notification_service.dart';
import 'services/prayer_times_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  // Request notifications permission on app startup so notifications can function immediately
  await NotificationService.requestPermissions();
  NotificationService.schedulePrayerNotifications();
  AirtableService.fetchAirtableRecords();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MehrabApp(),
    ),
  );
}

class MehrabApp extends StatelessWidget {
  const MehrabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محراب الحوامدية',
      debugShowCheckedModeBanner: false,
      
      // Light Theme Configuration
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0B4C35),
        scaffoldBackgroundColor: const Color(0xFFF4F7F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B4C35),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0B4C35),
          secondary: Color(0xFFD4AF37), // Gold
          surface: Color(0xFFE4EBE7),
          background: Color(0xFFF4F7F5),
        ),
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme).copyWith(
          titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: const Color(0xFF0B4C35)),
          bodyMedium: GoogleFonts.cairo(fontWeight: FontWeight.w600, color: const Color(0xFF0B4C35)),
        ),
      ),

      // Dark Theme Configuration
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0B4C35),
        scaffoldBackgroundColor: const Color(0xFF072A1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B4C35),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0B4C35),
          secondary: Color(0xFFD4AF37), // Gold
          surface: Color(0xFF103A2B),
          background: Color(0xFF072A1E),
        ),
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
          titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: GoogleFonts.cairo(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),

      themeMode: Provider.of<ThemeProvider>(context).themeMode,

      // Localization for Arabic Support
      locale: const Locale('ar', 'EG'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'EG'), // Arabic
      ],

      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  SharedPreferences? _prefs;
  AudioPlayer? _adhanPlayer;
  Timer? _prayerCheckTimer;
  String? _activeAdhanPrayer;

  final List<Widget> _screens = [
    const HomeScreen(),
    const RecitersScreen(),
    const SaadHamoudaScreen(),
    const QuranScreen(),
    const AzkarScreen(),
    const TasbihScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _adhanPlayer = AudioPlayer();
    _initPrefs();
    // Check prayer times every 15 seconds
    _prayerCheckTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _checkAdhanTriggers();
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // Run an initial check after a tiny delay
    Future.delayed(const Duration(seconds: 2), () {
      _checkAdhanTriggers();
    });
  }

  @override
  void dispose() {
    _prayerCheckTimer?.cancel();
    _adhanPlayer?.dispose();
    super.dispose();
  }

  void _checkAdhanTriggers() {
    final prefs = _prefs;
    if (prefs == null) return;

    final bool isEnabled = prefs.getBool('prayer_notifications_enabled') ?? true;
    if (!isEnabled) return;

    // Do not trigger if already showing an Adhan
    if (_activeAdhanPrayer != null) return;

    final DateTime now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";

    // Calculate prayer times
    final prayerTimes = PrayerTimesService.calculatePrayerTimes();
    final Map<String, DateTime> times = {
      'الفجر': prayerTimes.fajr,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    times.forEach((prayerName, prayerTime) {
      final localPrayerTime = prayerTime.toLocal();
      final difference = now.difference(localPrayerTime);
      // Only trigger if current time is within 60 seconds of the actual local prayer time
      if (difference.inSeconds >= 0 && difference.inSeconds <= 60) {
        final String lastTriggerKey = "last_triggered_adhan_$prayerName";
        final String? lastTriggeredDate = prefs.getString(lastTriggerKey);
        
        if (lastTriggeredDate != todayStr) {
          prefs.setString(lastTriggerKey, todayStr);
          _triggerAdhanPopup(prayerName);
        }
      }
    });
  }

  void _triggerAdhanPopup(String prayerName) async {
    // 1. Pause any active recitation / media audio in the app
    try {
      Provider.of<AudioProvider>(context, listen: false).pause();
    } catch (e) {
      print("Could not pause AudioProvider: $e");
    }

    // 2. Play the Adhan audio using the correct asset path 'images/adhan.mp3'
    try {
      await _adhanPlayer?.setAsset('images/adhan.mp3');
      _adhanPlayer?.setLoopMode(LoopMode.off);
      _adhanPlayer?.play();
    } catch (e) {
      print("Error playing Adhan audio asset: $e");
    }

    // 3. Show full-screen overlay
    setState(() {
      _activeAdhanPrayer = prayerName;
    });
  }

  void _stopAdhan() {
    _adhanPlayer?.stop();
    setState(() {
      _activeAdhanPrayer = null;
    });
  }

  Widget _buildAdhanOverlay(String prayerName) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.85),
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              colors: [Color(0xFF0E5C41), Color(0xFF02100A)],
              radius: 1.2,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Pulsing Islamic Icon
                _PulsingLogo(),
                
                const SizedBox(height: 40),
                
                // Title
                Text(
                  'حان الآن موعد أذان',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
                Text(
                  'صلاة $prayerName',
                  style: GoogleFonts.cairo(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                Text(
                  'حسب التوقيت المحلي لمدينة الحوامدية وضواحيها',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white60,
                  ),
                ),
                
                const Spacer(),
                
                // Stop Adhan Button
                GestureDetector(
                  onTap: _stopAdhan,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade900.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.volume_off, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'إيقاف الأذان',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF072A1E),
            selectedItemColor: const Color(0xFFD4AF37), // Gold
            unselectedItemColor: const Color(0xFF5A7A6E),
            selectedLabelStyle: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w600),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mic_none),
                activeIcon: Icon(Icons.mic),
                label: 'القراء',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined),
                activeIcon: Icon(Icons.school),
                label: 'دروس وخطب',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                activeIcon: Icon(Icons.menu_book),
                label: 'المصحف',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chrome_reader_mode_outlined),
                activeIcon: Icon(Icons.chrome_reader_mode),
                label: 'الأذكار',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.circle_outlined),
                activeIcon: Icon(Icons.circle),
                label: 'السبحة',
              ),
            ],
          ),
        ),
        if (_activeAdhanPrayer != null)
          _buildAdhanOverlay(_activeAdhanPrayer!),
      ],
    );
  }
}

class _PulsingLogo extends StatefulWidget {
  @override
  State<_PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<_PulsingLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD4AF37).withOpacity(0.05 + 0.05 * _controller.value),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.2 + 0.3 * _controller.value),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.notifications_active,
            size: 80,
            color: const Color(0xFFD4AF37).withOpacity(0.7 + 0.3 * _controller.value),
          ),
        );
      },
    );
  }
}
