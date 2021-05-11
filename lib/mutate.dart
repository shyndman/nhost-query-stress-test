import 'dart:math';

import 'package:graphql/client.dart';
import 'stats.dart';

import 'shared.dart';

final todosQuery = gql('''
  {
    todos {
      id
      name
      is_completed
      created_at
      updated_at
    }
  }
''');

final setTodoCompletedMutation = gql(r'''
  mutation($todo_id: uuid!, $is_completed: Boolean!) {
    update_todos_by_pk(
      pk_columns: {id: $todo_id},
      _set: {is_completed: $is_completed}
    ) {
      id
    }
  }
''');

void main() async {
  final clients = await createNhostClients();
  final gqlClient = clients.gqlClient;

  final todosResult = await gqlClient.query(QueryOptions(document: todosQuery));
  final todos = (todosResult.data!['todos'] as List<Object?>)
      .cast<Map<String, dynamic>>();

  final r = Random();
  final mutationDurationsMs = <int>[];

  for (var i = 0; i < 500; i++) {
    final mutationTarget = todos[r.nextInt(todos.length)];

    final sw = Stopwatch()..start();
    await gqlClient.mutate(MutationOptions(
      document: setTodoCompletedMutation,
      variables: {
        'todo_id': mutationTarget['id'],
        'is_completed': r.nextBool(),
      },
    ));
    mutationDurationsMs.add(sw.elapsedMilliseconds);
    print('($i) ${sw.elapsedMilliseconds}ms');
  }

  print('\nstats:');
  printStats(mutationDurationsMs, postfix: 'ms');

  clients.nhostClient.close();
}
