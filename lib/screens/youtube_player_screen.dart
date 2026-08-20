import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;

  const YoutubePlayerScreen({
    super.key,
    required this.videoId,
    required this.title,
  });

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showControls: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        backgroundColor: const Color(0xFF0B4C35),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            colors: [Color(0xFF0E5C41), Color(0xFF051E15)],
            radius: 1.2,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
