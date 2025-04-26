import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post.dart';
import '../../controllers/post_controller.dart';
import 'post_header.dart';
import '../comments/comment_card.dart';
import '../comments/comment_input.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Function(String) onCommentSubmitted;
  final Map<String, dynamic>? currentUser;
  final TextEditingController? commentController; 
  final VoidCallback? onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.onCommentSubmitted,
    this.currentUser,
    this.commentController, 
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostController(
        post: post,
        onCommentSubmitted: onCommentSubmitted,
        currentUser: currentUser,
        onDelete: onDelete,
        externalCommentController: commentController, 
      ),
      child: Consumer<PostController>(
        builder: (context, controller, _) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: const Color.fromARGB(255, 218, 211, 211)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostHeader(
                    post: post,
                    isCurrentUserPost: controller.isCurrentUserPost,
                    onOptionsPressed: () => controller.showPostOptions(context),
                  ),
                  const SizedBox(height: 12),
                  Text(post.content, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: controller.toggleComments,
                      ),
                      Text(post.comments.length.toString()),
                      const Spacer(),
                    ],
                  ),
                  if (controller.showComments) ...[
                    const Divider(),
                    CommentList(comments: post.comments),
                    CommentInput(
                      controller: controller.commentController,
                      onSubmitted: controller.submitComment,
                      currentUserAvatar: currentUser?['profile_pic'],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}