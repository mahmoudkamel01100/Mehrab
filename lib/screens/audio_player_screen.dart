import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services
import '../services/audio_handler.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, provider, child) {
        if (provider.currentTrackName == null) {
          return const Scaffold(
            body: Center(
              child: Text('لا يوجد ملف قيد التشغيل حالياً'),
            ),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              // Radial Background
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Column(
                            children: [
                              const Text(
                                'يتم التشغيل الآن',
                                style: TextStyle(fontSize: 10, color: Color(0xFFA3C8BC), fontWeight: FontWeight.bold),
                              ),
                              Text(
                                provider.currentReciterName!,
                                style: const TextStyle(fontSize: 13, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(width: 48), // spacer balance
                        ],
                      ),
                      
                      // Artwork / Mosque Circular Illustration
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD4AF37), width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4AF37).withOpacity(0.25),
                              blurRadius: 30,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 190,
                            height: 190,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF093B2A),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.mosque,
                                size: 80,
                                color: Color(0xFFD4AF37),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Track Details
                      Column(
                        children: [
                          Text(
                            provider.currentTrackName!,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'القرآن الكريم كامل ومحاضرات دينية',
                            style: TextStyle(fontSize: 11, color: Color(0xFFA3C8BC), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      
                      // Progress Bar & Sliders
                      Column(
                        children: [
                          StreamBuilder<Duration?>(
                            stream: provider.durationStream,
                            builder: (context, durationSnapshot) {
                              final duration = durationSnapshot.data ?? Duration.zero;
                              
                              return StreamBuilder<Duration>(
                                stream: provider.positionStream,
                                builder: (context, positionSnapshot) {
                                  var position = positionSnapshot.data ?? Duration.zero;
                                  if (position > duration) {
                                    position = duration;
                                  }
                                  
                                  return Column(
                                    children: [
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 4,
                                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                                          activeTrackColor: const Color(0xFFD4AF37),
                                          inactiveTrackColor: Colors.white10,
                                          thumbColor: const Color(0xFFD4AF37),
                                        ),
                                        child: Slider(
                                          min: 0.0,
                                          max: duration.inMilliseconds.toDouble(),
                                          value: position.inMilliseconds.toDouble().clamp(0.0, duration.inMilliseconds.toDouble()),
                                          onChanged: (value) {
                                            provider.seek(Duration(milliseconds: value.toInt()));
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.between,
                                          children: [
                                            Text(_formatDuration(position), style: const TextStyle(fontSize: 10, color: Color(0xFFA3C8BC))),
                                            Text(_formatDuration(duration), style: const TextStyle(fontSize: 10, color: Color(0xFFA3C8BC))),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      
                      // Player Controls Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Loop Button
                          IconButton(
                            icon: Icon(
                              Icons.repeat,
                              color: provider.isRepeat ? const Color(0xFFD4AF37) : Colors.white60,
                            ),
                            iconSize: 22,
                            onPressed: () {
                              provider.toggleRepeat();
                            },
                          ),
                          const SizedBox(width: 32),
                          
                          // Play/Pause Big Button
                          GestureDetector(
                            onTap: () => provider.togglePlay(),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD4AF37),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFD4AF37),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                    spreadRadius: -2,
                                  )
                                ],
                              ),
                              child: Icon(
                                provider.isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 36,
                                color: const Color(0xFF072A1E),
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          
                          // Share Button
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white60),
                            iconSize: 22,
                            onPressed: () {
                              // Share logic (in production could use share_plus package)
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24), // spacing bottom
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
