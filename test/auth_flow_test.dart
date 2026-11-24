import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/login.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('protected Project form requires a successful token login', (
    WidgetTester tester,
  ) async {
    final ApiClient apiClient = ApiClient(
      client: MockClient((http.Request request) async {
        expect(request.url.path, '/api/v1/auth/token/');
        final Map<String, dynamic> body =
            jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['username'], 'owner');
        expect(body['password'], 'secret');
        return http.Response(jsonEncode(<String, String>{'token': 'abc'}), 200);
      }),
      baseUrl: 'https://example.com',
    );

    await tester.pumpWidget(MyApp(apiClient: apiClient));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('login-username-field')),
      'owner',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password-field')),
      'secret',
    );
    await tester.tap(find.byKey(const ValueKey('login-submit-button')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(ProjectFormPage), findsOneWidget);
  });

  testWidgets('invalid credentials remain on Login with an error', (
    WidgetTester tester,
  ) async {
    final ApiClient apiClient = ApiClient(
      client: MockClient((_) async => http.Response('{}', 400)),
      baseUrl: 'https://example.com',
    );

    await tester.pumpWidget(MyApp(apiClient: apiClient));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('login-username-field')),
      'wrong',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password-field')),
      'wrong',
    );
    await tester.tap(find.byKey(const ValueKey('login-submit-button')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Username atau password tidak valid.'), findsOneWidget);
  });
}
