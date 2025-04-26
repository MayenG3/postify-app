class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
  try {
    return Comment(
      id: json['id']?.toString() ?? '0',
      userId: json['user']?['id']?.toString() ?? '0',
      userName: json['user']?['username'] ?? 'Usuario',
      userAvatar: json['user']?['profile_pic'] ?? 'https://i.pravatar.cc/150',
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  } catch (e) {
    rethrow;
  }
}
}