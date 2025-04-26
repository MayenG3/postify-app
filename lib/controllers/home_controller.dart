import 'package:flutter/material.dart';
import 'package:postify_app/models/post.dart';
import '../models/comment.dart';
import '../services/post_service.dart';
import '../services/comment_service.dart';
import '../utils/snackbar_service.dart';

class HomeController with ChangeNotifier {
  final PostService _postService;
  final CommentService _commentService;
  final Map<String, dynamic> user;
  final BuildContext context;

  List<Post> _posts = [];
  bool _isLoading = true;
  bool _isCreatingPost = false;
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  HomeController({
    required this.context,
    required this.user,
    required PostService postService,
    required CommentService commentService,
  })  : _postService = postService,
        _commentService = commentService;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isCreatingPost => _isCreatingPost;
  TextEditingController get postController => _postController;
  TextEditingController get commentController => _commentController;

  Future<void> loadPosts() async {
    if (!context.mounted) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _postService.getAllPosts();

      if (result.hasException) {
        throw result.exception ?? Exception('Error desconocido');
      }

      final postsData = result.data?['findAllPosts'] as List<dynamic>? ?? [];
      if (!context.mounted) return;

      _posts = postsData.map((post) => Post.fromJson(post)).toList();
    } catch (e) {
      if (context.mounted) {
        SnackbarService.showError(
          context: context,
          message: 'Error al cargar posts: ${e.toString()}',
        );
      }
    } finally {
      if (context.mounted) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> createPost() async {
    if (_postController.text.isEmpty) return;

    _isCreatingPost = true;
    notifyListeners();

    try {
      final userId = int.tryParse(user['id'].toString()) ?? 0;
      if (userId == 0) throw Exception('ID de usuario inválido');

      final result = await _postService.createPost(
        _postController.text,
        userId,
      );

      if (result.hasException) {
        throw result.exception ?? Exception('Error al crear post');
      }

      if (!context.mounted) return;

      final responseData = result.data?['createPost'];
      if (responseData == null) throw Exception('Respuesta del servidor vacía');

      final newPost = Post(
        id: responseData['id']?.toString() ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId.toString(),
        userName: user['username'] ?? 'Usuario',
        userAvatar: user['profile_pic'] ?? 'https://i.pravatar.cc/150',
        content: responseData['content'] ?? _postController.text,
        createdAt: responseData['created_at'] != null
            ? DateTime.parse(responseData['created_at'])
            : DateTime.now(),
        comments: [],
      );

      _posts.insert(0, newPost);
      _postController.clear();
      notifyListeners();

      if (context.mounted) {
        SnackbarService.showSuccess(
          context: context,
          message: 'Post creado exitosamente',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarService.showError(
          context: context,
          message: 'Error al crear post: ${e.toString()}',
        );
      }
    } finally {
      if (context.mounted) {
        _isCreatingPost = false;
        notifyListeners();
      }
    }
  }

  Future<void> createComment(String postId) async {
    if (_commentController.text.isEmpty) return;

    try {
      final result = await _commentService.createComment(
        postId,
        user['id'].toString(),
        _commentController.text,
      );

      if (result.hasException) {
        throw result.exception ?? Exception('Error al crear comentario');
      }

      final responseData = result.data?['createComment'];
      if (responseData == null) throw Exception('Respuesta del servidor vacía');

      final newComment = Comment(
        id: responseData['id']?.toString() ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
        userId: user['id']?.toString() ?? '0',
        userName: user['username'] ?? 'Usuario',
        userAvatar: user['profile_pic'] ?? 'https://i.pravatar.cc/150',
        content: responseData['content'] ?? _commentController.text,
        createdAt: DateTime.now(),
      );

      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex].comments.insert(0, newComment);
      }
      _commentController.clear();
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        SnackbarService.showError(
          context: context,
          message: 'Error al crear comentario: ${e.toString()}',
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
    _commentController.dispose();
  }
}