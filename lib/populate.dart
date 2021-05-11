import 'package:graphql/client.dart';

import 'shared.dart';

final addTodoMutation = gql(r'''
  mutation($todo: todos_insert_input!) {
    insert_todos(objects: [$todo]) {
      affected_rows
    }
  }
''');

void main() async {
  final clients = await createNhostClients();
  final gqlClient = clients.gqlClient;

  for (var i = 0; i < 300; i++) {
    final queryResult = await gqlClient.mutate(MutationOptions(
      document: addTodoMutation,
      variables: {
        'todo': {
          'name': 'Todo $i',
        },
      },
    ));
  }

  clients.nhostClient.close();
}
