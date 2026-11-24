import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
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

  test('ApiClient authenticates, creates a Project, and logs out', () async {
    final List<http.Request> requests = <http.Request>[];
    final ApiClient apiClient = ApiClient(
      client: MockClient((http.Request request) async {
        requests.add(request);
        if (request.url.path.endsWith('/auth/token/')) {
          return http.Response(
            jsonEncode(<String, String>{'token': 'abc'}),
            200,
          );
        }
        if (request.url.path.endsWith('/auth/logout/')) {
          return http.Response('', 204);
        }
        final Map<String, dynamic> payload =
            jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode(<String, dynamic>{'id': 'project-id', ...payload}),
          201,
        );
      }),
      baseUrl: 'https://example.com',
    );

    final String token = await apiClient.login(
      username: 'owner',
      password: 'secret',
    );
    final Project project = await apiClient.createProject(
      const Project(
        title: 'Project API',
        description: 'Created with a token.',
        techStack: 'Flutter, DRF',
        projectUrl: 'https://example.com/project',
      ),
      token,
    );
    await apiClient.logout(token);

    expect(token, 'abc');
    expect(project.id, 'project-id');
    expect(requests, hasLength(3));
    expect(requests[1].headers['authorization'], 'Token abc');
    expect(requests[2].headers['authorization'], 'Token abc');
  });

  test('ApiClient creates Experience with token authorization', () async {
    final ApiClient apiClient = ApiClient(
      client: MockClient((http.Request request) async {
        expect(request.url.path, '/api/v1/experiences/');
        expect(request.headers['authorization'], 'Token abc');
        final Map<String, dynamic> payload =
            jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode(<String, dynamic>{
            'id': 'experience-id',
            ...payload,
            'category_display': 'Research',
            'started_at': '2026-11-24T08:00:00Z',
            'ended_at': null,
            'is_ongoing': true,
            'skill_list': <String>['Python'],
            'star_count': 0,
            'is_starred': false,
          }),
          201,
        );
      }),
      baseUrl: 'https://example.com',
    );

    final Experience created = await apiClient.createExperience(
      const Experience(
        title: 'Research Assistant',
        description: 'Supported a research project.',
        category: 'research',
        skills: 'Python',
      ),
      'abc',
    );

    expect(created.id, 'experience-id');
    expect(created.categoryDisplay, 'Research');
  });
}
