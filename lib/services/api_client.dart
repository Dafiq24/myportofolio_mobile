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

  Future<String> login({
    required String username,
    required String password,
  }) async {
    final http.Response response = await _client.post(
      _endpoint('auth/token/'),
      headers: <String, String>{'content-type': 'application/json'},
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw ApiException(
        response.statusCode == 400
            ? 'Username atau password tidak valid.'
            : 'Login gagal. Silakan coba lagi.',
        statusCode: response.statusCode,
      );
    }

    final Object? decodedResponse = jsonDecode(response.body);
    if (decodedResponse is! Map<String, dynamic> ||
        decodedResponse['token'] is! String) {
      throw const ApiException('Format respons login tidak valid.');
    }

    return decodedResponse['token'] as String;
  }

  Future<void> logout(String token) async {
    final http.Response response = await _client.post(
      _endpoint('auth/logout/'),
      headers: <String, String>{'authorization': 'Token $token'},
    );

    if (response.statusCode != 204 && response.statusCode != 401) {
      throw ApiException(
        'Logout gagal di server.',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Project> createProject(Project project, String token) async {
    final http.Response response = await _client.post(
      _endpoint('projects/'),
      headers: <String, String>{
        'authorization': 'Token $token',
        'content-type': 'application/json',
      },
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode != 201) {
      throw ApiException(switch (response.statusCode) {
        401 => 'Sesi berakhir. Silakan login kembali.',
        403 => 'Hanya pemilik portofolio yang dapat menambah proyek.',
        _ => 'Proyek gagal disimpan. Silakan periksa kembali datanya.',
      }, statusCode: response.statusCode);
    }

    final Object? decodedResponse = jsonDecode(response.body);
    if (decodedResponse is! Map<String, dynamic>) {
      throw const ApiException('Format proyek tersimpan tidak valid.');
    }

    return Project.fromJson(decodedResponse);
  }
}
