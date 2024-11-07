import 'package:flutter/material.dart';
import 'audio_service.dart'; // Import the audio service

void showSettings(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: const SettingsPage(),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'))
          ],
        );
      });
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double bgmVolume =
      AudioService.bgmVolume; // Set default BGM volume from the service
  double sfxVolume =
      AudioService.sfxVolume; // Set default SFX volume from the service
  double masterVolume =
      AudioService.masterVolume; // Set default master volume from the service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Master Volume"),
            Slider(
              value: masterVolume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: (masterVolume * 100).toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  masterVolume = value;
                  AudioService.setMasterVolume(value); // Update master volume
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("Background Music Volume"),
            Slider(
              value: bgmVolume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: (bgmVolume * 100).toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  bgmVolume = value;
                  AudioService.setBgmVolume(value); // Update BGM volume
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("Sound Effects Volume"),
            Slider(
              value: sfxVolume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: (sfxVolume * 100).toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  sfxVolume = value;
                  AudioService.setSfxVolume(value); // Update SFX volume
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
