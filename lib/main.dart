import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
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

  final List<Widget> _screens = [
    const HomeScreen(),
    const RecitersScreen(),
    const SaadHamoudaScreen(),
    const QuranScreen(),
    const AzkarScreen(),
    const TasbihScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
