import 'package:flutter/material.dart';
import '../../models/post.dart';

class PostController with ChangeNotifier {
  final Post post;
  final Function(String) onCommentSubmitted;
  final Map<String, dynamic>? currentUser;
  final VoidCallback? onDelete;
  final TextEditingController? externalCommentController;
  
  late final TextEditingController _commentController;
  bool _isDisposed = false;
  bool _showComments = false;

  PostController({
    required this.post,
    required this.onCommentSubmitted,
    this.currentUser,
    this.onDelete,
    this.externalCommentController,
  }) : _commentController = externalCommentController ?? TextEditingController();

  bool get showComments => _showComments;
  
  TextEditingController get commentController {
    if (_isDisposed) {
      throw StateError('Cannot access commentController after dispose');
    }
    return _commentController;
  }

  bool get isCurrentUserPost =>
      currentUser != null && post.userId == currentUser!['id'].toString();

  void toggleComments() {
    if (!_isDisposed) {
      _showComments = !_showComments;
      safeNotifyListeners();
    }
  }

  void submitComment() {
    if (!_isDisposed && _commentController.text.isNotEmpty) {
      onCommentSubmitted(_commentController.text);
      _commentController.clear();
      safeNotifyListeners();
    }
  }

  void showPostOptions(BuildContext context) {
    if (_isDisposed) return;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar post'),
            onTap: () {
              Navigator.pop(context);
              // Implementar edición
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Eliminar post', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              if (!_isDisposed) {
                onDelete?.call();
              }
            },
          ),
        ],
      ),
    );
  }

  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      if (externalCommentController == null) {
        try {
          _commentController.dispose();
        } catch (e) {
          // Ignorar errores si ya estaba disposed
        }
      }
      super.dispose();
    }
  }
}