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
  static void playSoundFx() {
    FlameAudio.play(
      'sample_sound_fx.mp3',
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
    playSoundFx(); // Update the sound effects with the new volume
  }

  // Update master volume (affects both BGM and SFX)
  static void setMasterVolume(double volume) {
    masterVolume = volume;
    playBackgroundMusic(); // Reapply volume to BGM
    playSoundFx(); // Reapply volume to SFX
  }
}
