import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/state/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.apiClient, this.initialAuthToken});

  final ApiClient? apiClient;
  final String? initialAuthToken;

  @override
  Widget build(BuildContext context) {
    final ApiClient resolvedApiClient = apiClient ?? ApiClient();

    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: resolvedApiClient),
        ChangeNotifierProvider<AuthState>(
          create: (_) => AuthState(
            apiClient: resolvedApiClient,
            initialToken: initialAuthToken,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'MyPortfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            secondary: Colors.amber[700],
          ),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
