import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _endpoint(String path) {
    final String normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$normalizedBaseUrl/api/v1/$path');
  }

  Future<List<Project>> fetchProjects() async {
    final http.Response response = await _client.get(_endpoint('projects/'));

    if (response.statusCode != 200) {
      throw ApiException(
        'Gagal memuat proyek. Silakan coba lagi.',
        statusCode: response.statusCode,
      );
    }

    final Object? decodedResponse = jsonDecode(response.body);
    if (decodedResponse is! List<dynamic>) {
      throw const ApiException('Format data proyek tidak valid.');
    }

    return decodedResponse
        .map(
          (dynamic item) => Project.fromJson(
            Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
          ),
        )
        .toList(growable: false);
  }

  Future<Project> fetchProject(String projectId) async {
    final http.Response response = await _client.get(
      _endpoint('projects/$projectId/'),
    );

    if (response.statusCode != 200) {
      throw ApiException(
        response.statusCode == 404
            ? 'Proyek tidak ditemukan.'
            : 'Gagal memuat detail proyek. Silakan coba lagi.',
        statusCode: response.statusCode,
      );
    }

    final Object? decodedResponse = jsonDecode(response.body);
    if (decodedResponse is! Map<String, dynamic>) {
      throw const ApiException('Format detail proyek tidak valid.');
    }

    return Project.fromJson(decodedResponse);
  }
}
