import 'package:flutter/material.dart';
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
  String _currentPhrase = 'سبحان الله وبحمده';
  String _currentBenefit = 'كلمتان خفيفتان على اللسان ثقيلتان في الميزان';

  final List<Map<String, String>> _phrases = [
    { 'text': 'سبحان الله وبحمده', 'benefit': 'كلمتان خفيفتان على اللسان ثقيلتان في الميزان' },
    { 'text': 'الحمد لله', 'benefit': 'تملأ الميزان بالخيرات' },
    { 'text': 'لا إله إلا الله وحده لا شريك له', 'benefit': 'كانت له عدل عشر رقاب، وكتبت له مئة حسنة' },
    { 'text': 'الله أكبر', 'benefit': 'أحب الكلام إلى الله' },
    { 'text': 'أستغفر الله العظيم وأتوب إليه', 'benefit': 'تجلب الرزق وتغفر الذنوب' }
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
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                colors: [Color(0xFF0E5C41), Color(0xFF051E15)],
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF166E4F),
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Expanded(
                        child: Text(
                          _currentPhrase,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<Map<String, String>>(
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        onSelected: (Map<String, String> phrase) {
                          setState(() {
                            _currentPhrase = phrase['text']!;
                            _currentBenefit = phrase['benefit']!;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return _phrases.map((phrase) {
                            return PopupMenuItem<Map<String, String>>(
                              value: phrase,
                              child: Text(phrase['text']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),
                
                // Benefit Display
                SizedBox(
                  height: 48,
                  child: Center(
                    child: Text(
                      _currentBenefit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, height: 1.4),
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
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                        borderRadius: BorderRadius.circular(16),
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
}
