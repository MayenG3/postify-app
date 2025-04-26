import 'package:graphql_flutter/graphql_flutter.dart';

class ApiService {
  final GraphQLClient client;

  ApiService({required this.client});

  Future<QueryResult> login(String email, String password) async {
    const String loginMutation = """
      mutation Login(\$email: String!, \$password: String!) {
        login(loginInput: { email: \$email, password: \$password }) {
          access_token
          user {
            id
            name
            lastname
            username
            profile_pic
            email
          }
        }
      }
    """;

    final MutationOptions options = MutationOptions(
      document: gql(loginMutation),
      variables: {
        'email': email,
        'password': password,
      },
    );

    return await client.mutate(options);
  }
}
