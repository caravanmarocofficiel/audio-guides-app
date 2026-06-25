import 'package:just_audio/just_audio.dart';

class AudioPlaybackService {
  late final AudioPlayer _audioPlayer;
  
  static final AudioPlaybackService _instance = AudioPlaybackService._internal();

  Duration _remainingTrialTime = const Duration(seconds: 60);
  bool _isTrialMode = true;
  bool _isPlaying = false;

  AudioPlaybackService._internal() {
    _audioPlayer = AudioPlayer();
  }

  factory AudioPlaybackService() {
    return _instance;
  }

  AudioPlayer get player => _audioPlayer;
  bool get isPlaying => _isPlaying;
  bool get isTrialMode => _isTrialMode;
  Duration get remainingTrialTime => _remainingTrialTime;

  // ==================== Initialize ====================
  Future<void> initialize() async {
    try {
      await _audioPlayer.setSpeed(1.0);
    } catch (e) {
      print('Audio initialization error: $e');
    }
  }

  // ==================== Stream Audio (No Download) ====================
  /// تحميل الصوت من URL (Streaming فقط - بدون حفظ محلي)
  Future<bool> loadAudioStream(String audioUrl, {int? limitSeconds}) async {
    try {
      // معالجة الـ URL للقيود الزمنية (إذا كانت نسخة تجريبية)
      String finalUrl = audioUrl;
      if (limitSeconds != null) {
        finalUrl = '$audioUrl?limit=${limitSeconds}s';
      }

      await _audioPlayer.setUrl(finalUrl);
      print('Audio stream loaded: $finalUrl');
      return true;
    } catch (e) {
      print('Error loading audio stream: $e');
      return false;
    }
  }

  // ==================== Playback Control ====================
  Future<void> play() async {
    try {
      await _audioPlayer.play();
      _isPlaying = true;
    } catch (e) {
      print('Play error: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
    } catch (e) {
      print('Pause error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      await _audioPlayer.seek(Duration.zero);
    } catch (e) {
      print('Stop error: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Seek error: $e');
    }
  }

  // ==================== Trial Mode Management ====================
  /// بدء النسخة التجريبية (60 ثانية مجانية)
  void startTrialMode() {
    _isTrialMode = true;
    _remainingTrialTime = const Duration(seconds: 60);
    print('Trial mode started - 60 seconds free');
  }

  /// إيقاف النسخة التجريبية (بعد الدفع)
  void disableTrialMode() {
    _isTrialMode = false;
    _remainingTrialTime = Duration.zero;
    print('Trial mode disabled - Full access granted');
  }

  /// تحديث الوقت المتبقي من النسخة التجريبية
  void updateTrialTime(Duration remaining) {
    _remainingTrialTime = remaining;
    if (remaining.inSeconds <= 0) {
      pause();
      print('Trial time expired!');
    }
  }

  /// فحص ما إذا انتهت النسخة التجريبية
  bool isTrialExpired() {
    return _isTrialMode && _remainingTrialTime.inSeconds <= 0;
  }

  // ==================== Playback Status Stream ====================
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration?> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get bufferedPositionStream => _audioPlayer.bufferedPositionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  // ==================== Speed Control ====================
  Future<void> setSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed);
    } catch (e) {
      print('Speed control error: $e');
    }
  }

  // ==================== Volume Control ====================
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      print('Volume control error: $e');
    }
  }

  // ==================== Cleanup ====================
  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
    } catch (e) {
      print('Dispose error: $e');
    }
  }

  // ==================== Get Current Info ====================
  Duration? getCurrentPosition() => _audioPlayer.position;
  Duration? getDuration() => _audioPlayer.duration;
}
