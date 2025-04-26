import 'package:graphql_flutter/graphql_flutter.dart';

class UserService {
  final GraphQLClient client;

  UserService({required this.client});

  Future<QueryResult> getUser(int userId) async {
    const String query = '''
      query FindOneUser(\$findOneUserId: Int!) {
        findOneUser(id: \$findOneUserId) {
          id
          username
          email
          name
          lastname
          profile_pic
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {'findOneUserId': userId},
    );

    return await client.query(options);
  }

  Future<QueryResult> updateUser(int userId, Map<String, dynamic> updateData) async {
    const String mutation = '''
      mutation UpdateUser(\$updateUserInput: UpdateUserInput!) {
        updateUser(updateUserInput: \$updateUserInput) {
          id
          username
          email
          name
          lastname
          profile_pic
        }
      }
    ''';

    final inputData = Map<String, dynamic>.from(updateData);
    inputData['id'] = userId;

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'updateUserInput': inputData,
      },
    );

    return await client.mutate(options);
  }
}