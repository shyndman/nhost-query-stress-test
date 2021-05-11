import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:graphql/client.dart';
import 'package:nhost_graphql_adapter/nhost_graphql_adapter.dart';
import 'package:nhost_sdk/nhost_sdk.dart';

export 'stats.dart';

Future<NhostClients> createNhostClients() async {
  dotenv.load(); // Load .env file

  final client = NhostClient(baseUrl: dotenv.env['backend_url']!);
  await client.auth
      .login(email: dotenv.env['email']!, password: dotenv.env['password']!);
  print('logged in');

  return NhostClients(
    nhostClient: client,
    gqlClient: createNhostGraphQLClient(dotenv.env['gql_url']!, client),
  );
}

class NhostClients {
  NhostClients({
    required this.nhostClient,
    required this.gqlClient,
  });
  final NhostClient nhostClient;
  final GraphQLClient gqlClient;
}
