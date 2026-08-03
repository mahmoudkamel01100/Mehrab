import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:adhan/adhan.dart';

// Services
import '../services/prayer_times_service.dart';
import '../services/hijri_helper.dart';
import '../services/audio_handler.dart';

// Screens
import 'audio_player_screen.dart';
import 'settings_screen.dart';
import 'reciters_screen.dart';
import 'saad_hamouda_screen.dart';
import 'azkar_screen.dart';
import 'tasbih_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PrayerTimes _prayerTimes;
  late String _hijriDate;
  late String _gregorianDate;
  
  Timer? _countdownTimer;
  String _nextPrayerCountdown = '';
  String _nextPrayerName = '';

  @override
  void initState() {
    super.initState();
    _prayerTimes = PrayerTimesService.calculatePrayerTimes();
    _hijriDate = HijriHelper.getTodayHijri();
    
    // Formatting Gregorian Date in Arabic
    _gregorianDate = intl.DateFormat('EEEE، d MMMM yyyy', 'ar_EG').format(DateTime.now());
    
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'images/MehrabLogo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'مِحرَاب الحَوامدية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            ),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _hijriDate,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    _gregorianDate,
                    style: const TextStyle(fontSize: 8, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        backgroundColor: const Color(0xFF0B4C35),
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Prayer Times Widget
                _buildPrayerTimesWidget(),
                const SizedBox(height: 16),
                
                // Social Links
                _buildSocialLinks(),
                const SizedBox(height: 16),
                
                // Quick Navigation Cards
                _buildQuickNavigation(),
                const SizedBox(height: 80), // Spacer for bottom mini player
              ],
            ),
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

  Widget _buildPrayerTimesWidget() {
    // Highlight next upcoming prayer
    final nextPrayer = _prayerTimes.nextPrayer();
    final isNone = nextPrayer == Prayer.none;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF103A2B).withOpacity(0.8) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مواقيت الصلاة (الحوامدية)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF0B4C35),
                ),
              ),
              const ContainerBadge(text: 'أوفلاين', color: Colors.green),
            ],
          ),
          if (_nextPrayerName.isNotEmpty && _nextPrayerCountdown.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.12),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.35)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined, color: Color(0xFFD4AF37), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'متبقي على أذان $_nextPrayerName: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isDark ? Colors.white70 : const Color(0xFF0B4C35),
                    ),
                  ),
                  Text(
                    _nextPrayerCountdown,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.1,
            children: [
              _buildPrayerCard('الفجر', _prayerTimes.fajr, nextPrayer == Prayer.fajr || isNone),
              _buildPrayerCard('الشروق', _prayerTimes.sunrise, nextPrayer == Prayer.sunrise),
              _buildPrayerCard('الظهر', _prayerTimes.dhuhr, nextPrayer == Prayer.dhuhr),
              _buildPrayerCard('العصر', _prayerTimes.asr, nextPrayer == Prayer.asr),
              _buildPrayerCard('المغرب', _prayerTimes.maghrib, nextPrayer == Prayer.maghrib),
              _buildPrayerCard('العشاء', _prayerTimes.isha, nextPrayer == Prayer.isha),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(String name, DateTime time, bool isActive) {
    final timeStr = intl.DateFormat('h:mm a', 'ar_EG').format(time);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [const Color(0xFFD4AF37).withOpacity(0.2), const Color(0xFF0B4C35).withOpacity(isDark ? 0.3 : 0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isActive ? null : (isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? const Color(0xFFD4AF37) : (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05)),
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              color: isActive
                  ? const Color(0xFFD4AF37)
                  : (isDark ? const Color(0xFFA3C8BC) : const Color(0xFF5A7A6E)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeStr,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isActive ? (isDark ? Colors.white : const Color(0xFFD4AF37)) : (isDark ? Colors.white : const Color(0xFF0B4C35)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return GestureDetector(
      onTap: () {}, // Open Facebook URL in production
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1877F2).withOpacity(0.15),
          border: Border.all(color: const Color(0xFF1877F2).withOpacity(0.4)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(FontAwesomeIcons.facebook, color: Color(0xFF1877F2), size: 20),
            SizedBox(width: 12),
            Text(
              'زيارة صفحة فيسبوك',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickNavigation() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildNavGridItem('قراء الحوامدية', Icons.book_outlined, Colors.green, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecitersScreen()),
          );
        }),
        _buildNavGridItem('د. سعد حمودة', Icons.school_outlined, const Color(0xFFD4AF37), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SaadHamoudaScreen()),
          );
        }),
        _buildNavGridItem('الأذكار', Icons.menu_book, Colors.blue, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AzkarScreen()),
          );
        }),
        _buildNavGridItem('السبحة', Icons.circle_outlined, Colors.red, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TasbihScreen()),
          );
        }),
      ],
    );
  }

  Widget _buildNavGridItem(String title, IconData icon, Color color, VoidCallback onTap) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.white : const Color(0xFF0B4C35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _updateCountdown(); // Run immediately on start
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final todayTimes = PrayerTimesService.calculatePrayerTimesFor(now);
    final tomorrow = now.add(const Duration(days: 1));
    final tomorrowTimes = PrayerTimesService.calculatePrayerTimesFor(tomorrow);
    
    DateTime nextPrayerTime;
    String prayerNameAr = '';
    
    if (now.isBefore(todayTimes.fajr)) {
      nextPrayerTime = todayTimes.fajr;
      prayerNameAr = 'الفجر';
    } else if (now.isBefore(todayTimes.sunrise)) {
      nextPrayerTime = todayTimes.sunrise;
      prayerNameAr = 'الشروق';
    } else if (now.isBefore(todayTimes.dhuhr)) {
      nextPrayerTime = todayTimes.dhuhr;
      prayerNameAr = 'الظهر';
    } else if (now.isBefore(todayTimes.asr)) {
      nextPrayerTime = todayTimes.asr;
      prayerNameAr = 'العصر';
    } else if (now.isBefore(todayTimes.maghrib)) {
      nextPrayerTime = todayTimes.maghrib;
      prayerNameAr = 'المغرب';
    } else if (now.isBefore(todayTimes.isha)) {
      nextPrayerTime = todayTimes.isha;
      prayerNameAr = 'العشاء';
    } else {
      nextPrayerTime = tomorrowTimes.fajr;
      prayerNameAr = 'الفجر';
    }
    
    final difference = nextPrayerTime.difference(now);
    
    final hours = difference.inHours.toString().padLeft(2, '0');
    final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
    
    if (mounted) {
      setState(() {
        _nextPrayerName = prayerNameAr;
        _nextPrayerCountdown = '$hours:$minutes:$seconds';
        _prayerTimes = todayTimes;
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

class ContainerBadge extends StatelessWidget {
  final String text;
  final Color color;

  const ContainerBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, provider, child) {
        if (provider.currentTrackName == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AudioPlayerScreen()),
            );
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF0B4C35), const Color(0xFF072A1E)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.25)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.play_circle_fill, color: Color(0xFFD4AF37), size: 28),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.currentTrackName!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        Text(
                          provider.currentReciterName!,
                          style: const TextStyle(color: Color(0xFFA3C8BC), fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    provider.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    provider.togglePlay();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
