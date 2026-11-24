import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/state/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('experience form validates input and displays every value', (
    WidgetTester tester,
  ) async {
    final ApiClient apiClient = ApiClient(
      client: MockClient((http.Request request) async {
        expect(request.headers['authorization'], 'Token test-token');
        final Map<String, dynamic> payload =
            jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode(<String, dynamic>{
            'id': 'experience-id',
            ...payload,
            'category_display': 'Full-Time',
            'started_at': '2026-11-24T08:00:00Z',
            'ended_at': null,
            'is_ongoing': true,
            'skill_list': <String>['Student Advocacy', 'Content Development'],
            'star_count': 0,
            'is_starred': false,
          }),
          201,
        );
      }),
      baseUrl: 'https://example.com',
    );
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          ChangeNotifierProvider<AuthState>(
            create: (_) =>
                AuthState(apiClient: apiClient, initialToken: 'test-token'),
          ),
        ],
        child: const MaterialApp(home: ExperienceFormPage()),
      ),
    );

    final Finder saveButton = find.byKey(
      const ValueKey('save-experience-button'),
    );
    final Finder formScrollView = find.byKey(
      const ValueKey('experience-form-scroll-view'),
    );

    Future<void> tapSaveButton() async {
      await tester.pumpAndSettle();
      await tester.drag(formScrollView, const Offset(0, -1000));
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
    }

    await tapSaveButton();

    expect(find.text('Role title tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Description tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('experience-title-field')),
      'Advocacy & Student Welfare Intern',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-organization-field')),
      'BEM Fasilkom UI',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-period-field')),
      'September 2025 - December 2025',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-order-field')),
      '-1',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-description-field')),
      'Coordinated a student welfare activity for more than 100 participants.',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-thumbnail-field')),
      'example.com/activity.jpg',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-skills-field')),
      'Student Advocacy, Content Development',
    );

    await tapSaveButton();

    expect(
      find.text('Urutan timeline harus berada di antara 0 dan 32767.'),
      findsOneWidget,
    );
    expect(
      find.text('URL dokumentasi harus memakai http atau https.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('experience-order-field')),
      '4',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-thumbnail-field')),
      'https://example.com/activity.jpg',
    );

    await tapSaveButton();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Experience berhasil ditambahkan!'), findsOneWidget);
    expect(
      find.text('Role Title: Advocacy & Student Welfare Intern'),
      findsOneWidget,
    );
    expect(find.text('Organization: BEM Fasilkom UI'), findsOneWidget);
    expect(find.text('Timeline Position: 4'), findsOneWidget);
    expect(find.text('Employment Type: Full-Time'), findsOneWidget);
    expect(
      find.text('Documentation URL: https://example.com/activity.jpg'),
      findsOneWidget,
    );
    expect(
      find.text('Related Skills: Student Advocacy, Content Development'),
      findsOneWidget,
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Advocacy & Student Welfare Intern'), findsNothing);
  });

  testWidgets('expired Experience session is cleared after a 401 response', (
    WidgetTester tester,
  ) async {
    final ApiClient apiClient = ApiClient(
      client: MockClient((http.Request request) async {
        expect(request.method, 'POST');
        expect(request.headers['authorization'], 'Token expired-token');
        return http.Response('{}', 401);
      }),
      baseUrl: 'https://example.com',
    );
    final AuthState authState = AuthState(
      apiClient: apiClient,
      initialToken: 'expired-token',
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          ChangeNotifierProvider<AuthState>.value(value: authState),
        ],
        child: const MaterialApp(home: ExperienceFormPage()),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('experience-title-field')),
      'Expired Session Experience',
    );
    await tester.enterText(
      find.byKey(const ValueKey('experience-description-field')),
      'This request should clear the expired authentication session.',
    );
    await tester.drag(
      find.byKey(const ValueKey('experience-form-scroll-view')),
      const Offset(0, -1000),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-experience-button')));
    await tester.pumpAndSettle();

    expect(authState.isAuthenticated, isFalse);
    expect(authState.token, isNull);
    expect(find.text('Sesi berakhir. Silakan login kembali.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
