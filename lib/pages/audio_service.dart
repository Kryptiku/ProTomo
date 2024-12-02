import 'package:flame_audio/flame_audio.dart';

class AudioService {
  static double bgmVolume = 0.2;
  static double sfxVolume = 0.2;
  static double masterVolume = 1.0;

  // Play background music
  static Future<void> playBackgroundMusic() async {
    await FlameAudio.bgm.stop(); // Stop any currently playing music
    await FlameAudio.bgm.play(
      'sample_bg_music.mp3',
      volume: bgmVolume * masterVolume,
    );
  }

  // Play sound effect
  static void buttonPressFx() {
    FlameAudio.play(
      'button_press.wav',
      volume: sfxVolume * masterVolume,
    );
  }
  static void coinFx() {
    FlameAudio.play(
      'coin.wav',
      volume: sfxVolume * masterVolume,
    );
  }
  static void popupNoFx() {
    FlameAudio.play(
      'popup_no.wav',
      volume: sfxVolume * masterVolume,
    );
  }
  static void popupYesFx() {
    FlameAudio.play(
      'popup_yes.wav',
      volume: sfxVolume * masterVolume,
    );
  }
  static void startFocusFx() {
    FlameAudio.play(
      'start_focus.wav',
      volume: sfxVolume * masterVolume,
    );
  }

  static void stopTimeFx() {
    FlameAudio.play(
      'stop_time.wav',
      volume: sfxVolume * masterVolume,
    );
  }

  // Update background music volume
  static void setBgmVolume(double volume) {
    bgmVolume = volume;
    playBackgroundMusic(); // Update the music with the new volume
  }

  // Update sound effects volume
  static void setSfxVolume(double volume) {
    sfxVolume = volume;
  }

  // Update master volume (affects both BGM and SFX)
  static void setMasterVolume(double volume) {
    masterVolume = volume;
    playBackgroundMusic(); // Reapply volume to BGM
  }
}
