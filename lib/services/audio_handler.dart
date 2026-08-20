import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isRepeat = false;

  String? _currentTrackName;
  String? _currentReciterName;
  String? _currentUrl;

  AudioProvider() {
    // Listen to playing events directly from just_audio
    _audioPlayer.playingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });

    // Listen to playback state to handle track ending
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_isRepeat) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.play();
        } else {
          _isPlaying = false;
          notifyListeners();
        }
      }
    });
  }

  // Getters
  bool get isPlaying => _isPlaying;
  bool get isRepeat => _isRepeat;
  String? get currentTrackName => _currentTrackName;
  String? get currentReciterName => _currentReciterName;
  String? get currentUrl => _currentUrl;

  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// Plays audio from a URL, setting track metadata
  void play(String url, String trackName, String reciterName) async {
    try {
      _currentUrl = url;
      _currentTrackName = trackName;
      _currentReciterName = reciterName;
      notifyListeners();

      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  /// Toggles play/pause state
  void togglePlay() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      if (_currentUrl != null) {
        _audioPlayer.play();
      }
    }
  }

  /// Pauses the audio playback
  void pause() {
    _audioPlayer.pause();
  }

  /// Seeks to a specific position in the track
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  /// Toggles repeat mode
  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
