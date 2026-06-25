import 'package:flutter/material.dart';
import '../services/audio_service.dart';
from 'just_audio/just_audio.dart';
import '../config/app_config.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlaybackService _audioService = AudioPlaybackService();
  
  bool _isPlaying = false;
  bool _isTrialMode = true;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  Duration _remainingTrialTime = const Duration(seconds: AppConfig.freeTrialSeconds);
  String? _error;

  bool get isPlaying => _isPlaying;
  bool get isTrialMode => _isTrialMode;
  Duration get currentPosition => _currentPosition;
  Duration get duration => _duration;
  Duration get remainingTrialTime => _remainingTrialTime;
  String? get error => _error;

  AudioProvider() {
    _initializeAudio();
  }

  // ==================== Initialize Audio Service ====================
  Future<void> _initializeAudio() async {
    try {
      await _audioService.initialize();
      _setupListeners();
    } catch (e) {
      _error = 'Failed to initialize audio: $e';
      notifyListeners();
    }
  }

  void _setupListeners() {
    _audioService.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _audioService.positionStream.listen((position) {
      if (position != null) {
        _currentPosition = position;
        if (_isTrialMode && _remainingTrialTime.inSeconds > 0) {
          _remainingTrialTime = _remainingTrialTime - const Duration(seconds: 1);
        }
        notifyListeners();
      }
    });

    _audioService.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration;
        notifyListeners();
      }
    });
  }

  // ==================== Load Audio ====================
  Future<bool> loadAudio(String audioUrl, {bool isTrialMode = false}) async {
    try {
      _isTrialMode = isTrialMode;
      if (isTrialMode) {
        _remainingTrialTime = const Duration(seconds: AppConfig.freeTrialSeconds);
      } else {
        _remainingTrialTime = Duration.zero;
      }
      
      bool success = await _audioService.loadAudioStream(
        audioUrl,
        limitSeconds: isTrialMode ? AppConfig.freeTrialSeconds : null,
      );
      
      if (success) {
        _error = null;
      } else {
        _error = 'Failed to load audio';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _error = 'Error loading audio: $e';
      notifyListeners();
      return false;
    }
  }

  // ==================== Playback Controls ====================
  Future<void> play() async {
    if (_isTrialMode && _remainingTrialTime.inSeconds <= 0) {
      _error = 'Trial time expired';
      notifyListeners();
      return;
    }
    await _audioService.play();
  }

  Future<void> pause() async {
    await _audioService.pause();
  }

  Future<void> stop() async {
    await _audioService.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  // ==================== Speed Control ====================
  Future<void> setSpeed(double speed) async {
    await _audioService.setSpeed(speed);
  }

  // ==================== Volume Control ====================
  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
  }

  // ==================== Trial Mode Management ====================
  void enablePremiumMode() {
    _audioService.disableTrialMode();
    _isTrialMode = false;
    _remainingTrialTime = Duration.zero;
    notifyListeners();
  }

  void resetTrialMode() {
    _audioService.startTrialMode();
    _isTrialMode = true;
    _remainingTrialTime = const Duration(seconds: AppConfig.freeTrialSeconds);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
