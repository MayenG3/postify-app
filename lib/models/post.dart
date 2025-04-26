
import './comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.comments,
  });
  

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      final userId =
          json['user']?['id']?.toString() ?? json['user_id']?.toString() ?? '0';

      final userName = json['user']?['username'] ?? 'Usuario';
      final userAvatar =
          json['user']?['profile_pic'] ?? 'https://i.pravatar.cc/150';

      return Post(
        id: json['id']?.toString() ?? '0',
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
        content: json['content'] ?? '',
        createdAt:
            json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : DateTime.now(),
        comments:
            (json['comment'] as List<dynamic>?)
                ?.map((comment) => Comment.fromJson(comment))
                .toList() ??
            [],
      );
    } catch (e) {
      rethrow;
    }
  }
}


