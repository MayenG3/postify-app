import 'package:graphql_flutter/graphql_flutter.dart';

class CommentService {
  final GraphQLClient client;

  CommentService({required this.client});

  Future<QueryResult> createComment(
    String postId, 
    String userId, 
    String content,
  ) async {

    final int parsedPostId = int.tryParse(postId) ?? 0;
    final int parsedUserId = int.tryParse(userId) ?? 0;
    if (parsedPostId <= 0 || parsedUserId <= 0) {
      throw Exception('IDs inválidos para el backend');
    }

    const String mutation = """
      mutation CreateComment(\$input: CreateCommentInput!) {
        createComment(createCommentInput: \$input) {
          id
          content
          created_at
        }
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      variables: {
        'input': {
          'post_id': parsedPostId,
          'user_id': parsedUserId,
          'content': content,
        },
      },
    );

    try {
      final result = await client.mutate(options);
      return result;
    } catch (e) {
      rethrow; 
    }
  }
}
