import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  test('ApiClient loads Project data from the versioned endpoint', () async {
    final MockClient httpClient = MockClient((http.Request request) async {
      expect(request.url.toString(), 'https://example.com/api/v1/projects/');
      return http.Response(
        jsonEncode(<Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'project-id',
            'title': 'MyPortfolio',
            'description': 'A portfolio project.',
            'tech_stack': 'Flutter, Django',
            'project_url': 'https://example.com/project',
            'project_image_url': '',
          },
        ]),
        200,
        headers: <String, String>{'content-type': 'application/json'},
      );
    });
    final ApiClient apiClient = ApiClient(
      client: httpClient,
      baseUrl: 'https://example.com/',
    );

    final List<Project> projects = await apiClient.fetchProjects();

    expect(projects, hasLength(1));
    expect(projects.single.title, 'MyPortfolio');
    expect(projects.single.techStack, 'Flutter, Django');
  });

  test('ApiClient exposes a friendly error for failed requests', () async {
    final ApiClient apiClient = ApiClient(
      client: MockClient(
        (_) async => http.Response('Service unavailable', 503),
      ),
      baseUrl: 'https://example.com',
    );

    expect(
      apiClient.fetchProjects,
      throwsA(
        isA<ApiException>()
            .having((ApiException error) => error.statusCode, 'statusCode', 503)
            .having(
              (ApiException error) => error.message,
              'message',
              'Gagal memuat proyek. Silakan coba lagi.',
            ),
      ),
    );
  });
}
