import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'home_screen.dart'; // For MiniPlayerWidget

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  String _currentPhrase = 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ';
  String _currentBenefit = 'كلمتان خفيفتان على اللسان ثقيلتان في الميزان حبيبتان إلى الرحمن';

  final List<Map<String, String>> _phrases = [
    { 'text': 'سُبْحَانَ اللَّهِ', 'benefit': 'يكتب له ألف حسنة أو يحط عنه ألف خطيئة' },
    { 'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', 'benefit': 'حُطَّتْ خَطَايَاهُ وَإِنْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ' },
    { 'text': 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ', 'benefit': 'تَمْلَآَنِ مَا بَيْنَ السَّمَاوَاتِ وَالْأَرْضِ' },
    { 'text': 'سُبْحَانَ اللهِ العَظِيمِ وَبِحَمْدِهِ', 'benefit': 'غرست له نخلة في الجنة' },
    { 'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ', 'benefit': 'كلمتان خفيفتان على اللسان ثقيلتان في الميزان حبيبتان إلى الرحمن' },
    { 'text': 'لَا إلَه إلّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلُّ شَيْءِ قَدِيرِ', 'benefit': 'كانت له عدل عشر رقاب، وكتبت له مئة حسنة، ومحيت عنه مئة سيئة' },
    { 'text': 'لا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ', 'benefit': 'كنز من كنوز الجنة' },
    { 'text': 'الْحَمْدُ للّهِ رَبِّ الْعَالَمِينَ', 'benefit': 'تملأ ميزان العبد بالحسنات' },
    { 'text': 'الْلَّهُم صَلِّ وَسَلِم وَبَارِك عَلَى سَيِّدِنَا مُحَمَّد', 'benefit': 'من صلى علي حين يصبح وحين يمسي أدركته شفاعتي يوم القيامة' },
    { 'text': 'أستغفر الله العظيم وأتوب إليه', 'benefit': 'سنة النبي صلى الله عليه وسلم وتجلب الرزق وتغفر الذنوب' },
    { 'text': 'سُبْحَانَ الْلَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا الْلَّهُ، وَالْلَّهُ أَكْبَرُ', 'benefit': 'أحب الكلام إلى الله، ومكفرات للذنوب، وغرس الجنة' },
    { 'text': 'لَا إِلَهَ إِلَّا اللَّهُ', 'benefit': 'أفضل الذكر لا إله إلا الله' },
    { 'text': 'الْلَّهُ أَكْبَرُ', 'benefit': 'كتبت له عشرون حسنة وحطت عنه عشرون سيئة' },
    { 'text': 'سُبْحَانَ اللَّهِ ، وَالْحَمْدُ لِلَّهِ ، وَلا إِلَهَ إِلا اللَّهُ ، وَاللَّهُ أَكْبَرُ ، اللَّهُمَّ اغْفِرْ لِي ، اللَّهُمَّ ارْحَمْنِي ، اللَّهُمَّ ارْزُقْنِي', 'benefit': 'خير الدنيا والآخرة' },
    { 'text': 'الْحَمْدُ لِلَّهِ حَمْدًا كَثِيرًا طَيِّبًا مُبَارَكًا فِيهِ', 'benefit': 'ابتدرها اثنا عشر ملكاً أيهم يرفعها' },
    { 'text': 'اللَّهُ أَكْبَرُ كَبِيرًا ، وَالْحَمْدُ لِلَّهِ كَثِيرًا ، وَسُبْحَانَ اللَّهِ بُكْرَةً وَأَصِيلاً', 'benefit': 'فتحت لها أبواب السماء' },
    { 'text': 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ', 'benefit': 'تحط عنه عشر خطايا ويرفع له عشر درجات ويصلي الله عليه عشراً' },
  ];

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  // Load counter from local storage
  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('tasbihCount') ?? 0;
    });
  }

  // Save counter to local storage
  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
    });
    await prefs.setInt('tasbihCount', _counter);
  }

  void _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = 0;
    });
    await prefs.setInt('tasbihCount', _counter);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('السبحة الإلكترونية', style: TextStyle(fontWeight: FontWeight.bold)),
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
                colors: isDark
                    ? const [Color(0xFF0E5C41), Color(0xFF051E15)]
                    : const [Color(0xFFEBF2EE), Color(0xFFD6E2DB)],
                radius: 1.2,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phrase Selector Card
                GestureDetector(
                  onTap: () => _showPhraseSelectionBottomSheet(context, isDark),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF166E4F) : Colors.white,
                      border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: isDark
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'اضغط هنا لاختيار ذكر للتسبيح',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isDark ? Colors.white.withOpacity(0.8) : const Color(0xFF0B4C35).withOpacity(0.8),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Color(0xFFD4AF37),
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Full Selected Phrase display (completely visible, multi-line wrapping)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Text(
                    _currentPhrase,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0B4C35),
                      height: 1.5,
                    ),
                  ),
                ),
                
                // Benefit Display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    _currentBenefit,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ),
                
                // Large Tasbih Circle Counter
                Center(
                  child: GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFF166E4F), Color(0xFF0B4C35)],
                        ),
                        border: Border.all(color: const Color(0xFFD4AF37), width: 8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _counter.toString(),
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'اضغط للتسبيح',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Reset Controller Button
                Center(
                  child: GestureDetector(
                    onTap: _resetCounter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                        border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04)),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isDark
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
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.refresh, color: Color(0xFFD4AF37), size: 18),
                          SizedBox(width: 8),
                          Text('إعادة تعيين', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40), // spacing bottom for player
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

  void _showPhraseSelectionBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0B4C35) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Grab handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white30 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'اختر الذكر للتسبيح',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF0B4C35),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: _phrases.length,
                  itemBuilder: (context, index) {
                    final phrase = _phrases[index];
                    final bool isSelected = phrase['text'] == _currentPhrase;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      title: Text(
                        phrase['text']!,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                              ? const Color(0xFFD4AF37) 
                              : (isDark ? Colors.white : const Color(0xFF0B4C35)),
                        ),
                      ),
                      subtitle: Text(
                        phrase['benefit']!,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: isSelected 
                              ? const Color(0xFFD4AF37).withOpacity(0.8) 
                              : (isDark ? Colors.white60 : Colors.grey.shade600),
                        ),
                      ),
                      trailing: isSelected 
                          ? const Icon(Icons.check_circle, color: Color(0xFFD4AF37), size: 20) 
                          : null,
                      onTap: () {
                        setState(() {
                          _currentPhrase = phrase['text']!;
                          _currentBenefit = phrase['benefit']!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
