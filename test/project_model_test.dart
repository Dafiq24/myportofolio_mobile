import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/project.dart';

void main() {
  test('Project reads the Django API response contract', () {
    final Project project = Project.fromJson(<String, dynamic>{
      'id': '638e8d2c-604d-4070-96eb-1dcd563742b3',
      'title': 'MyPortfolio Mobile',
      'description': 'A Flutter portfolio application.',
      'tech_stack': 'Flutter, Django REST Framework',
      'project_url': 'https://github.com/Dafiq24/myportofolio_mobile',
      'project_image_url': 'https://example.com/portfolio.png',
    });

    expect(project.id, '638e8d2c-604d-4070-96eb-1dcd563742b3');
    expect(project.title, 'MyPortfolio Mobile');
    expect(project.techStack, 'Flutter, Django REST Framework');
    expect(
      project.projectUrl,
      'https://github.com/Dafiq24/myportofolio_mobile',
    );
    expect(project.projectImageUrl, 'https://example.com/portfolio.png');
  });

  test('Project creates the payload expected by Django', () {
    const Project project = Project(
      id: 'server-generated-id',
      title: 'REST Portfolio',
      description: 'A project created from Flutter.',
      techStack: 'Flutter, DRF',
      projectUrl: 'https://example.com/project',
    );

    expect(project.toJson(), <String, dynamic>{
      'title': 'REST Portfolio',
      'description': 'A project created from Flutter.',
      'tech_stack': 'Flutter, DRF',
      'project_url': 'https://example.com/project',
      'project_image_url': '',
    });
  });
}
