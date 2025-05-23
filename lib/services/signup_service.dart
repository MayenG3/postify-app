import 'package:graphql_flutter/graphql_flutter.dart';

class SignupService {
  final GraphQLClient client;

  SignupService({required this.client});

  Future<QueryResult> registerUser({
    required String name,
    required String lastname,
    required String username,
    required String email,
    required String password,
    required String profilePic,
  }) async {
    const String signupMutation = """
      mutation CreateUser(\$createUserInput: CreateUserInput!) {
        createUser(createUserInput: \$createUserInput) {
          id
          username
          email
          password
          name
          lastname
          profile_pic
        }
      }
    """;

    final MutationOptions options = MutationOptions(
      document: gql(signupMutation),
      variables: {
        'createUserInput': {
          'name': name,
          'lastname': lastname,
          'username': username,
          'email': email,
          'password': password,
          'profile_pic': profilePic,
        },
      },
    );

    return await client.mutate(options);
  }
}