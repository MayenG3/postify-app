import 'package:flutter/material.dart';
import 'package:postify_app/controllers/home_controller.dart';

class CreatePostDialog extends StatelessWidget {
  final HomeController controller;

  const CreatePostDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Crear nueva publicación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.postController,
              decoration: const InputDecoration(
                hintText: "Comparte tus pensamientos...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.createPost();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Publicar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, HomeController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreatePostDialog(controller: controller),
    );
  }
}