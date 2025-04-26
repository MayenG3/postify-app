import 'package:graphql_flutter/graphql_flutter.dart';

class PostService {
  final GraphQLClient client;

  PostService({required this.client});

  Future<QueryResult> getAllPosts() async {
    const String postsQuery = """
      query FindAllPosts {
        findAllPosts {
          id
          content
          created_at
          user {
            id
            username
            profile_pic
          }
          comment {
            id
            content
            created_at
            user {
              id
              username
              profile_pic
            }
          }
        }
      }
    """;

    final QueryOptions options = QueryOptions(
      document: gql(postsQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    return await client.query(options);
  }

  Future<QueryResult> createPost(String content, int userId) async {
    const String createPostMutation = """
    mutation CreatePost(\$createPostInput: CreatePostInput!) {
      createPost(createPostInput: \$createPostInput) {
        id
        content
        created_at
        user_id
      }
    }
  """;

    final options = MutationOptions(
      document: gql(createPostMutation),
      variables: {
        'createPostInput': {'content': content, 'user_id': userId},
      },
    );

    return await client.mutate(options);
  }

   Future<QueryResult> deletePost(int postId) async {
    const String deletePostMutation = """
      mutation RemovePost(\$removePostId: Int!) {
        removePost(id: \$removePostId) {
          id
        }
      }
    """;

    final options = MutationOptions(
      document: gql(deletePostMutation),
      variables: {
        'removePostId': postId,
      },
    );

    return await client.mutate(options);
  }

}

