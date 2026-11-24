import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/experience.dart';

void main() {
  test('Experience reads the complete Django API response contract', () {
    final Experience experience = Experience.fromJson(<String, dynamic>{
      'id': '638e8d2c-604d-4070-96eb-1dcd563742b3',
      'title': 'Teaching Staff',
      'organization': 'BETIS Fasilkom UI',
      'period': 'January 2026 - June 2026',
      'display_order': 2,
      'description': 'Taught students and prepared learning materials.',
      'category': 'part-time',
      'category_display': 'Part-Time',
      'thumbnail': 'https://example.com/activity.jpg',
      'started_at': '2026-01-10T08:30:00Z',
      'ended_at': null,
      'is_ongoing': true,
      'skills': 'Teaching, Communication',
      'skill_list': <String>['Teaching', 'Communication'],
      'star_count': 3,
      'is_starred': true,
    });

    expect(experience.id, '638e8d2c-604d-4070-96eb-1dcd563742b3');
    expect(experience.title, 'Teaching Staff');
    expect(experience.displayOrder, 2);
    expect(experience.categoryDisplay, 'Part-Time');
    expect(experience.startedAt, DateTime.utc(2026, 1, 10, 8, 30));
    expect(experience.endedAt, isNull);
    expect(experience.isOngoing, isTrue);
    expect(experience.skillList, <String>['Teaching', 'Communication']);
    expect(experience.starCount, 3);
    expect(experience.isStarred, isTrue);
  });

  test('Experience creates only the writable Django payload', () {
    final Experience experience = Experience(
      id: 'server-generated-id',
      title: 'Research Assistant',
      organization: 'Universitas Indonesia',
      period: '2026',
      displayOrder: 1,
      description: 'Supported an applied machine learning study.',
      category: 'research',
      categoryDisplay: 'Research',
      thumbnail: null,
      startedAt: DateTime.utc(2026),
      isOngoing: true,
      skills: 'Python, Research',
      skillList: const <String>['Python', 'Research'],
      starCount: 5,
      isStarred: true,
    );

    expect(experience.toJson(), <String, dynamic>{
      'title': 'Research Assistant',
      'organization': 'Universitas Indonesia',
      'period': '2026',
      'display_order': 1,
      'description': 'Supported an applied machine learning study.',
      'category': 'research',
      'thumbnail': null,
      'skills': 'Python, Research',
    });
  });
}
