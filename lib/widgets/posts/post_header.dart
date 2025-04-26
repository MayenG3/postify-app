import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/post.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final bool isCurrentUserPost;
  final VoidCallback onOptionsPressed;

  const PostHeader({
    super.key,
    required this.post,
    required this.isCurrentUserPost,
    required this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(post.userAvatar),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                timeago.format(post.createdAt),
                style: TextStyle(
                  color: const Color.fromARGB(255, 66, 65, 65),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (isCurrentUserPost)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: onOptionsPressed,
          ),
      ],
    );
  }
}