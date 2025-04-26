import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../services/comment_service.dart';
import '../services/post_service.dart';
import '../widgets/posts/post_card.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/home_bottom_bar.dart';
import '../widgets/posts/create_post_dialog.dart';
import '../widgets/posts/create_post_card.dart';
import '../widgets/home/scroll_to_top_button.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const HomeScreen({super.key, required this.token, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;
  int _currentIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final client = GraphQLProvider.of(context).value;
    _controller = HomeController(
      context: context,
      user: widget.user,
      postService: PostService(client: client),
      commentService: CommentService(client: client),
    );
    _controller.loadPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: const HomeAppBar(),
        body: Consumer<HomeController>(
          builder: (context, controller, _) {
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: controller.loadPosts,
                  child:
                      controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.posts.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return CreatePostCard(
                                  controller: controller,
                                  profilePic: widget.user['profile_pic'],
                                );
                              }
                              return PostCard(
                                post: controller.posts[index - 1],
                                currentUser: widget.user,
                                commentController: controller.commentController,
                                onCommentSubmitted: (comment) {
                                  controller.createComment(
                                    controller.posts[index - 1].id,
                                  );
                                },
                              );
                            },
                          ),
                ),
                ScrollToTopButton(scrollController: _scrollController),
              ],
            );
          },
        ),
        bottomNavigationBar: HomeBottomBar(
          currentIndex: _currentIndex,
          onIndexChanged: (index) => setState(() => _currentIndex = index),
          onCreatePost: () => CreatePostDialog.show(context, _controller),
          user: widget.user,
        ),
      ),
    );
  }
}
