import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter_tarot/data/nickname_data.dart';
import 'user_profile_dialog.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class UserProfileAvatar extends StatelessWidget {
  final String userId;
  final double radius;

  const UserProfileAvatar({
    super.key,
    required this.userId,
    this.radius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.purple,
            child: Icon(Icons.person, size: radius * 1.2, color: Colors.white54),
          );
        }
        
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final profileImage = data['profileImage'] as String?;
          if (profileImage != null && profileImage.isNotEmpty) {
            ImageProvider imageProvider;
            if (profileImage.startsWith('data:image')) {
              imageProvider = MemoryImage(base64Decode(profileImage.split(',').last));
            } else {
              imageProvider = AssetImage(profileImage);
            }
            
            return GestureDetector(
              onTap: () => _showProfileDialog(context, data, profileImage),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: Colors.indigo.shade900,
                backgroundImage: imageProvider,
              ),
            );
          }
        }

        return GestureDetector(
          onTap: snapshot.hasData ? () => _showProfileDialog(context, snapshot.data!.data() as Map<String, dynamic>, 'assets/images/witch_morgan.jpg') : null,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.purple,
            child: Icon(Icons.person, size: radius * 1.2, color: Colors.white),
          ),
        );
      },
    );
  }

  void _showProfileDialog(BuildContext context, Map<String, dynamic> data, String fallbackImage) {
    String displayName = AppLocalizations.of(context)!.defaultUserDisplayName;
    bool isCustomNickname = data['isCustomNickname'] ?? true;
    int? prefixIndex = data['nicknamePrefixIndex'];
    int? suffixIndex = data['nicknameSuffixIndex'];

    if (!isCustomNickname && prefixIndex != null && suffixIndex != null) {
      final prefix = getNicknamePrefixes(context)[prefixIndex];
      final suffix = getNicknameSuffixes(context)[suffixIndex];
      displayName = '$prefix $suffix';
    } else {
      displayName = data['nickname'] ?? displayName;
    }

    showDialog(
      context: context,
      builder: (context) => UserProfileDialog(
        nickname: displayName,
        profileImage: data['profileImage'] ?? fallbackImage,
        instagramUrl: data['instagramUrl'],
        facebookUrl: data['facebookUrl'],
        xUrl: data['xUrl'],
        bio: data['bio'],
      ),
    );
  }
}
