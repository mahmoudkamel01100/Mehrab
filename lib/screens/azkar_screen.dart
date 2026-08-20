import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Services
import '../services/azkar_data.dart';
import '../services/theme_provider.dart';

// Screens
import 'home_screen.dart'; // For MiniPlayerWidget

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  String _activeCategoryId = 'morning';
  final Map<String, List<Map<String, dynamic>>> _azkarStateMap = {};

  @override
  void initState() {
    super.initState();
    // Initialize state map for all categories
    for (var cat in AzkarData.categories) {
      _azkarStateMap[cat.id] = AzkarData.getCategoryItems(cat.id);
    }
  }

  List<Map<String, dynamic>> get _currentList {
    return _azkarStateMap[_activeCategoryId] ?? [];
  }

  void _resetCategoryAzkar() {
    setState(() {
      _azkarStateMap[_activeCategoryId] = AzkarData.getCategoryItems(_activeCategoryId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إعادة ضبط العدادات لهذا القسم', textDirection: TextDirection.rtl),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _resetSingleZekr(Map<String, dynamic> zekr) {
    setState(() {
      zekr['count'] = zekr['max'];
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final activeCat = AzkarData.categories.firstWhere(
      (c) => c.id == _activeCategoryId,
      orElse: () => AzkarData.categories.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          activeCat.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF0B4C35),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCategoryAzkar,
            tooltip: 'إعادة العدادات لهذا القسم',
          )
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                colors: isDark
                    ? const [Color(0xFF0E5C41), Color(0xFF051E15)]
                    : const [Color(0xFFEBF2EE), Color(0xFFD6E2DB)],
                radius: 1.2,
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              const SizedBox(height: 10),

              // Categories Selector Bar (Horizontal Scrollable Buttons)
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: AzkarData.categories.length,
                  itemBuilder: (context, index) {
                    final cat = AzkarData.categories[index];
                    final isSelected = cat.id == _activeCategoryId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeCategoryId = cat.id;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0B4C35)
                                : (isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.7)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0B4C35)
                                  : (isDark ? Colors.white12 : Colors.black12),
                            ),
                          ),
                          child: Text(
                            cat.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? const Color(0xFFA3C8BC) : const Color(0xFF0B4C35)),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Azkar Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 90.0, top: 4.0),
                  itemCount: _currentList.length,
                  itemBuilder: (context, index) {
                    final zekr = _currentList[index];
                    final int count = zekr['count'];
                    final bool isDone = count == 0;
                    final String benefit = zekr['benefit'] ?? '';

                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isDone ? 0.45 : 1.0,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isDark
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              if (count > 0) {
                                setState(() {
                                  zekr['count']--;
                                });
                                HapticFeedback.lightImpact();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Right Side: Digital Green Counter Widget (Matching Image)
                                    Container(
                                      width: 58,
                                      height: 58,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isDone
                                            ? (isDark ? Colors.white12 : Colors.grey.shade400)
                                            : const Color(0xFF00A884), // Digital Green
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: isDone
                                            ? null
                                            : [
                                                BoxShadow(
                                                  color: const Color(0xFF00A884).withOpacity(0.3),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                )
                                              ],
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          count.toString().padLeft(2, '0'),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.2,
                                            fontFamily: 'monospace', // Digital style look
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // Left Side: Zekr Text + Share + Benefit/Reference
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Zekr Arabic Text
                                          Text(
                                            zekr['text'] ?? '',
                                            style: TextStyle(
                                              fontSize: themeProvider.azkarFontSize,
                                              height: 1.75,
                                              fontWeight: FontWeight.w600,
                                              color: isDark ? Colors.white : const Color(0xFF1E272C),
                                            ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          if (benefit.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              benefit,
                                              style: TextStyle(
                                                fontSize: (themeProvider.azkarFontSize * 0.75).clamp(11.0, 18.0),
                                                height: 1.4,
                                                color: isDark
                                                    ? const Color(0xFF26A69A)
                                                    : const Color(0xFF00897B),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
          ),
        ],
      ),
    );
  }
}
