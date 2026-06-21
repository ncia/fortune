import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class UserProfileDialog extends StatelessWidget {
  final String nickname;
  final String profileImage;
  final String? instagramUrl;
  final String? facebookUrl;
  final String? xUrl;
  final String? bio;

  const UserProfileDialog({
    super.key,
    required this.nickname,
    required this.profileImage,
    this.instagramUrl,
    this.facebookUrl,
    this.xUrl,
    this.bio,
  });

  Future<void> _launchUrl(String urlString) async {
    // Basic URL validation/formatting
    var url = urlString.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (profileImage.startsWith('data:image')) {
      imageProvider = MemoryImage(base64Decode(profileImage.split(',').last));
    } else {
      imageProvider = AssetImage(profileImage);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        borderRadius: 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo.shade900,
                border: Border.all(color: Colors.amberAccent, width: 3),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Nickname
            Text(
              nickname,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Bio (If exists)
            if (bio != null && bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                bio!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 32),

            // SNS Icons
            if ((instagramUrl?.isNotEmpty ?? false) || 
                (facebookUrl?.isNotEmpty ?? false) || 
                (xUrl?.isNotEmpty ?? false)) ...[
              const Text(
                'SNS',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (instagramUrl?.isNotEmpty ?? false)
                    _buildSocialIcon(
                      icon: FontAwesomeIcons.instagram,
                      color: Colors.pinkAccent,
                      url: instagramUrl!,
                    ),
                  if (facebookUrl?.isNotEmpty ?? false)
                    _buildSocialIcon(
                      icon: FontAwesomeIcons.facebook,
                      color: Colors.blueAccent,
                      url: facebookUrl!,
                    ),
                  if (xUrl?.isNotEmpty ?? false)
                    _buildSocialIcon(
                      icon: FontAwesomeIcons.xTwitter,
                      color: Colors.white,
                      url: xUrl!,
                    ),
                ],
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Close Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white54,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.btnClose),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon({required dynamic icon, required Color color, required String url}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white10,
            border: Border.all(color: Colors.white24),
          ),
          child: FaIcon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}
