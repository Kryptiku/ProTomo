import 'package:flutter/material.dart';
import 'audio_service.dart'; // Ensure you have your audio service imported

void showSettings(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners for the dialog
        ),
        backgroundColor: Colors.transparent, // Transparent background
        child: SettingsDialog(),
      );
    },
  );
}

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  double bgmVolume = AudioService.bgmVolume; // Get initial value from service
  double sfxVolume = AudioService.sfxVolume;
  double masterVolume = AudioService.masterVolume;

  // Update methods to reflect changes to the service
  void updateMasterVolume(double value) {
    setState(() {
      masterVolume = value;
    });
    AudioService.setMasterVolume(value); // Update service
  }

  void updateBgmVolume(double value) {
    setState(() {
      bgmVolume = value;
    });
    AudioService.setBgmVolume(value); // Update service
  }

  void updateSfxVolume(double value) {
    setState(() {
      sfxVolume = value;
    });
    AudioService.setSfxVolume(value); // Update service
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500, // Adjusted height to make the dialog longer
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black54, // Dark background with transparency
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white, width: 2), // White border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.white, // Text color for visibility
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Adjust the settings below:",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Settings Content (Sliders)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Master Volume
                  const Text(
                    "Master Volume",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Slider(
                    value: masterVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: (masterVolume * 100).toStringAsFixed(0),
                    onChanged: updateMasterVolume, // Update state and service
                  ),
                  const SizedBox(height: 20),

                  // Background Music Volume
                  const Text(
                    "Background Music Volume",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Slider(
                    value: bgmVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: (bgmVolume * 100).toStringAsFixed(0),
                    onChanged: updateBgmVolume, // Update state and service
                  ),
                  const SizedBox(height: 20),

                  // Sound Effects Volume
                  const Text(
                    "Sound Effects Volume",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Slider(
                    value: sfxVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: (sfxVolume * 100).toStringAsFixed(0),
                    onChanged: updateSfxVolume, // Update state and service
                  ),
                ],
              ),
            ),
          ),

          // Close Button
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  AudioService.popupNoFx();
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
