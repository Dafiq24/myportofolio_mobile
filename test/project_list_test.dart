import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/project_detail.dart';
import 'package:myportofolio_mobile/screens/project_list.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Project list opens a complete Project detail', (
    WidgetTester tester,
  ) async {
    final Map<String, dynamic> project = <String, dynamic>{
      'id': 'project-id',
      'title': 'MyPortfolio Mobile',
      'description': 'A Flutter portfolio connected to Django.',
      'tech_stack': 'Flutter, Django REST Framework',
      'project_url': 'https://example.com/portfolio',
      'project_image_url': '',
    };
    final ApiClient apiClient = ApiClient(
      client: MockClient((http.Request request) async {
        if (request.url.path.endsWith('/projects/')) {
          return http.Response(jsonEncode(<Object>[project]), 200);
        }
        return http.Response(jsonEncode(project), 200);
      }),
      baseUrl: 'https://example.com',
    );

    await tester.pumpWidget(
      MaterialApp(home: ProjectListPage(apiClient: apiClient)),
    );
    await tester.pumpAndSettle();

    expect(find.text('MyPortfolio Mobile'), findsOneWidget);
    expect(find.text('Flutter, Django REST Framework'), findsOneWidget);

    await tester.tap(find.text('MyPortfolio Mobile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectDetailPage), findsOneWidget);
    expect(find.text('Detail Proyek'), findsOneWidget);
    expect(find.text('Deskripsi'), findsOneWidget);
    expect(
      find.text('A Flutter portfolio connected to Django.'),
      findsOneWidget,
    );
    expect(find.text('Tautan: https://example.com/portfolio'), findsOneWidget);
  });

  testWidgets('Project list displays an empty state', (
    WidgetTester tester,
  ) async {
    final ApiClient apiClient = ApiClient(
      client: MockClient((_) async => http.Response('[]', 200)),
      baseUrl: 'https://example.com',
    );

    await tester.pumpWidget(
      MaterialApp(home: ProjectListPage(apiClient: apiClient)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada proyek yang tersedia.'), findsOneWidget);
  });

  testWidgets('Project list displays an error and retry action', (
    WidgetTester tester,
  ) async {
    final ApiClient apiClient = ApiClient(
      client: MockClient((_) async => http.Response('error', 500)),
      baseUrl: 'https://example.com',
    );

    await tester.pumpWidget(
      MaterialApp(home: ProjectListPage(apiClient: apiClient)),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Gagal memuat proyek. Silakan coba lagi.'),
      findsOneWidget,
    );
    expect(find.text('Coba Lagi'), findsOneWidget);
  });
}
