import 'package:flutter/material.dart';
import 'package:postify_app/screens/profile_screen.dart';

class HomeBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onCreatePost;
  final Map<String, dynamic> user; 

  const HomeBottomBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.onCreatePost,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(
              128,
              128,
              128,
              0.3,
            ),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? Colors.black : Colors.grey,
              size: 28,
            ),
            onPressed: () => onIndexChanged(0),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: onCreatePost,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: currentIndex == 2 ? Colors.black : Colors.grey,
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: user['id']),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
