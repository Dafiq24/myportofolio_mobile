import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_detail.dart';
import 'package:myportofolio_mobile/screens/experience_list.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  final Map<String, dynamic> experience = <String, dynamic>{
    'id': 'experience-id',
    'title': 'Teaching Staff',
    'organization': 'BETIS Fasilkom UI',
    'period': 'January - June 2026',
    'display_order': 0,
    'description': 'Prepared materials and taught weekly classes.',
    'category': 'part-time',
    'category_display': 'Part-Time',
    'thumbnail': null,
    'started_at': '2026-01-10T08:30:00Z',
    'ended_at': null,
    'is_ongoing': true,
    'skills': 'Teaching, Communication',
    'skill_list': <String>['Teaching', 'Communication'],
    'star_count': 2,
    'is_starred': false,
  };

  testWidgets('Experience list opens its public detail page', (
    WidgetTester tester,
  ) async {
    final ApiClient apiClient = ApiClient(
      client: MockClient((http.Request request) async {
        if (request.url.path.endsWith('/experiences/')) {
          return http.Response(jsonEncode(<Object>[experience]), 200);
        }
        return http.Response(jsonEncode(experience), 200);
      }),
      baseUrl: 'https://example.com',
    );

    await tester.pumpWidget(
      MaterialApp(home: ExperienceListPage(apiClient: apiClient)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Teaching Staff'), findsOneWidget);
    expect(
      find.text('BETIS Fasilkom UI • Part-Time • January - June 2026'),
      findsOneWidget,
    );

    await tester.tap(find.text('Teaching Staff'));
    await tester.pumpAndSettle();

    expect(find.byType(ExperienceDetailPage), findsOneWidget);
    expect(find.text('Detail Experience'), findsOneWidget);
    expect(
      find.text('Prepared materials and taught weekly classes.'),
      findsOneWidget,
    );
    expect(find.text('Teaching, Communication'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Experience list renders empty and error states', (
    WidgetTester tester,
  ) async {
    int requestCount = 0;
    final ApiClient apiClient = ApiClient(
      client: MockClient((_) async {
        requestCount++;
        return requestCount == 1
            ? http.Response('error', 500)
            : http.Response('[]', 200);
      }),
      baseUrl: 'https://example.com',
    );

    await tester.pumpWidget(
      MaterialApp(home: ExperienceListPage(apiClient: apiClient)),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Gagal memuat Experience. Silakan coba lagi.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Coba Lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada Experience yang tersedia.'), findsOneWidget);
  });
}
