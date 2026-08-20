import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

// Services
import '../services/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0B4C35),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: Theme.of(context).brightness == Brightness.dark
                ? const [Color(0xFF0E5C41), Color(0xFF051E15)]
                : const [Color(0xFFEBF2EE), Color(0xFFD6E2DB)],
            radius: 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Theme Settings Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.04)
                      : Colors.black.withOpacity(0.04),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.08),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.palette, color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'مظهر التطبيق',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF0B4C35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Dark Theme Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? const Color(0xFF0B4C35)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: themeProvider.themeMode == ThemeMode.dark
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.dark_mode,
                                    size: 16,
                                    color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'الوضع الداكن',
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        
                        // Light Theme Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: themeProvider.themeMode == ThemeMode.light
                                    ? const Color(0xFFCCD7D0)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: themeProvider.themeMode == ThemeMode.light
                                      ? const Color(0xFF0B4C35)
                                      : Colors.grey.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.light_mode,
                                    size: 16,
                                    color: themeProvider.themeMode == ThemeMode.light
                                        ? const Color(0xFF0B4C35)
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'الوضع المضيء',
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.themeMode == ThemeMode.light
                                          ? const Color(0xFF0B4C35)
                                          : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // Azkar Font Size Settings Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.04)
                      : Colors.black.withOpacity(0.04),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.08),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.format_size, color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'حجم خط الأذكار',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF0B4C35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'صغير',
                          style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                        ),
                        Expanded(
                          child: Slider(
                            value: themeProvider.azkarFontSize,
                            min: 14.0,
                            max: 26.0,
                            divisions: 12,
                            label: themeProvider.azkarFontSize.toInt().toString(),
                            activeColor: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFF0B4C35),
                            inactiveColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.shade300,
                            onChanged: (newSize) {
                              themeProvider.setAzkarFontSize(newSize);
                            },
                          ),
                        ),
                        Text(
                          'كبير جداً',
                          style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        'حجم الخط الحالي: ${themeProvider.azkarFontSize.toInt()}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFD4AF37)
                              : const Color(0xFF0B4C35),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
