import 'package:audioplayers/audioplayers.dart';
import 'tts_service.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  
  AudioService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isBgmPlaying = false;
  bool _isMuted = false;
  double _volume = 0.5;

  bool get isMuted => _isMuted;
  double get volume => _volume;

  Future<void> init() async {
    // Set BGM to loop
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playMysteriousBgm() async {
    if (_isBgmPlaying) return;
    try {
      await _bgmPlayer.play(AssetSource('audio/bgm.mp3'), volume: _isMuted ? 0.0 : _volume);
      _isBgmPlaying = true;
    } catch (e) {
      print("Error playing BGM: $e");
    }
  }

  Future<void> stopBgm() async {
    if (!_isBgmPlaying) return;
    try {
      await _bgmPlayer.stop();
      _isBgmPlaying = false;
    } catch (e) {
      print("Error stopping BGM: $e");
    }
  }

  Future<void> playThunderSound() async {
    if (_isMuted) return;
    try {
      await _sfxPlayer.play(AssetSource('audio/thunder.ogg'), volume: _volume * 2.0);
    } catch (e) {
      print("Error playing thunder sound: $e");
    }
  }

  Future<void> pauseBgm() async {
    if (!_isBgmPlaying) return;
    try {
      await _bgmPlayer.pause();
      _isBgmPlaying = false;
    } catch (e) {
      print("Error pausing BGM: $e");
    }
  }

  Future<void> resumeBgm() async {
    try {
      await _bgmPlayer.resume();
      _isBgmPlaying = true;
    } catch (e) {
      print("Error resuming BGM: $e");
    }
  }

  Future<void> playCardFlipSfx() async {
    try {
      // Optional: Add a flip sound effect later
      // await _sfxPlayer.play(AssetSource('audio/flip.mp3'));
    } catch (e) {
      print("Error playing SFX: $e");
    }
  }

  Future<void> setVolume(double vol) async {
    _volume = vol;
    if (!_isMuted) {
      await _bgmPlayer.setVolume(_volume);
    }
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    if (_isMuted) {
      await _bgmPlayer.setVolume(0.0);
      TtsService().stop();
    } else {
      await _bgmPlayer.setVolume(_volume);
    }
  }
  
  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
