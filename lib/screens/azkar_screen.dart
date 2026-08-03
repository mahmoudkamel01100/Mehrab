import 'package:flutter/material.dart';

// Screens
import 'home_screen.dart'; // For MiniPlayerWidget

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  String _activeType = 'morning';

  // Original Data Lists
  final List<Map<String, dynamic>> _morningAzkar = [
    { 'id': 1, 'text': 'أصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.', 'max': 1, 'count': 1, 'benefit': 'من قالها حين يصبح وحين يمسي كفته من كل شيء.' },
    { 'id': 2, 'text': 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ.', 'max': 1, 'count': 1, 'benefit': 'أذكار الصباح المأثورة عن النبي ﷺ.' },
    { 'id': 3, 'text': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.', 'max': 3, 'count': 3, 'benefit': 'لم يضره من الله شيء.' },
    { 'id': 4, 'text': 'أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.', 'max': 3, 'count': 3, 'benefit': 'حفظ من لدغ العقرب والهوام.' },
    { 'id': 5, 'text': 'سُبْحَانَ اللهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.', 'max': 3, 'count': 3, 'benefit': 'تعدل ساعات طويلة من العبادة والذكر.' }
  ];

  final List<Map<String, dynamic>> _eveningAzkar = [
    { 'id': 1, 'text': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.', 'max': 1, 'count': 1, 'benefit': 'من قالها حين يصبح وحين يمسي كفته من كل شيء.' },
    { 'id': 2, 'text': 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ.', 'max': 1, 'count': 1, 'benefit': 'أذكار المساء المأثورة عن النبي ﷺ.' },
    { 'id': 3, 'text': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.', 'max': 3, 'count': 3, 'benefit': 'لم يضره من الله شيء.' },
    { 'id': 4, 'text': 'أَمْسَيْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ.', 'max': 1, 'count': 1, 'benefit': 'الاعتراف بالفطرة والإسلام.' },
    { 'id': 5, 'text': 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.', 'max': 3, 'count': 3, 'benefit': 'دعاء الكرب وتيسير الأمور.' }
  ];

  late List<Map<String, dynamic>> _currentList;

  @override
  void initState() {
    super.initState();
    _currentList = _morningAzkar;
  }

  void _resetAzkar() {
    setState(() {
      for (var zekr in _currentList) {
        zekr['count'] = zekr['max'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار اليومية', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0B4C35),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetAzkar,
            tooltip: 'إعادة العدادات',
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
              
              // Custom Slide Tab
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeType = 'morning';
                              _currentList = _morningAzkar;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _activeType == 'morning' ? const Color(0xFF0B4C35) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'أذكار الصباح',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _activeType == 'morning' ? Colors.white : const Color(0xFFA3C8BC),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeType = 'evening';
                              _currentList = _eveningAzkar;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _activeType == 'evening' ? const Color(0xFF0B4C35) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'أذكار المساء',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _activeType == 'evening' ? Colors.white : const Color(0xFFA3C8BC),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // List view
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 85.0),
                  itemCount: _currentList.length,
                  itemBuilder: (context, index) {
                    final zekr = _currentList[index];
                    final isDone = zekr['count'] == 0;
                    
                    return Opacity(
                      opacity: isDone ? 0.4 : 1.0,
                      child: GestureDetector(
                        onTap: () {
                          if (zekr['count'] > 0) {
                            setState(() {
                              zekr['count']--;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.04) : Colors.white,
                            border: Border.all(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: Theme.of(context).brightness == Brightness.dark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      zekr['text']!,
                                      style: const TextStyle(fontSize: 13, height: 1.6, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      zekr['benefit']!,
                                      style: const TextStyle(fontSize: 10, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isDone ? Colors.white24 : const Color(0xFFD4AF37),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  zekr['count'].toString(),
                                  style: TextStyle(
                                    color: isDone ? Colors.white60 : const Color(0xFF072A1E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 80), // Spacer for bottom mini player
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
}
