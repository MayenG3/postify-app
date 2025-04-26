import 'package:flutter/material.dart';
import 'package:postify_app/controllers/home_controller.dart';

class CreatePostCard extends StatelessWidget {
  final HomeController controller;
  final String? profilePic;
  final String? username;

  const CreatePostCard({
    super.key,
    required this.controller,
    this.profilePic,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color.fromARGB(255, 5, 11, 41)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    profilePic ?? 'https://i.pravatar.cc/150',
                  ),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.postController,
                          decoration: const InputDecoration(
                            hintText: "Comparte tus pensamientos...",
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      controller.isCreatingPost
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: controller.createPost,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text(
                                'Publicar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}