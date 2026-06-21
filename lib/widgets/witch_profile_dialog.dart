import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../data/witch_data.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

void showWitchProfileDialog(BuildContext context, Witch witch) {
  Widget buildProfileInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent,
                  image: DecorationImage(
                    image: AssetImage(witch.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                witch.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                witch.title,
                style: const TextStyle(fontSize: 14, color: Colors.pinkAccent),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildProfileInfo(AppLocalizations.of(context)!.chatProfileAge, '${witch.age}'),
                  buildProfileInfo(AppLocalizations.of(context)!.chatProfileBloodType, witch.bloodType),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildProfileInfo(AppLocalizations.of(context)!.chatProfileHeight, witch.height),
                  buildProfileInfo(AppLocalizations.of(context)!.chatProfileWeight, witch.weight),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.chatProfileBackground,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    witch.backgroundStory,
                    style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(AppLocalizations.of(context)!.chatProfileClose, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
