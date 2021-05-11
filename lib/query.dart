import 'package:graphql/client.dart';
import 'package:nhost_query_stress_test/shared.dart';

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

void main() async {
  final clients = await createNhostClients();
  final gqlClient = clients.gqlClient;

  final queryDurationsMs = <int>[];

  for (var i = 0; i < 500; i++) {
    final sw = Stopwatch()..start();
    await gqlClient.query(QueryOptions(
      document: todosQuery,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    ));
    queryDurationsMs.add(sw.elapsedMilliseconds);
    print('($i) ${sw.elapsedMilliseconds}ms');
  }

  print('\nstats:');
  printStats(queryDurationsMs, postfix: 'ms');

  clients.nhostClient.close();
}
