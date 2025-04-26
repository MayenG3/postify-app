import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String profilePic;
  final String name;
  final String username;

  const ProfileHeader({
    super.key,
    required this.profilePic,
    required this.name,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              profilePic.isNotEmpty ? profilePic : 'https://i.pravatar.cc/150?img=8',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            username,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}