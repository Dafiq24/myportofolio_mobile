import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    this.organization = '',
    this.period = '',
    this.displayOrder = 0,
    required this.description,
    this.category = 'full-time',
    this.categoryDisplay = '',
    this.thumbnail,
    this.startedAt,
    this.endedAt,
    this.isOngoing = true,
    this.skills = '',
    this.skillList = const <String>[],
    this.starCount = 0,
    this.isStarred = false,
  });

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String organization;
  final String period;
  final int displayOrder;
  final String description;
  final String category;
  @JsonKey(includeToJson: false)
  final String categoryDisplay;
  final String? thumbnail;
  @JsonKey(includeToJson: false)
  final DateTime? startedAt;
  @JsonKey(includeToJson: false)
  final DateTime? endedAt;
  @JsonKey(includeToJson: false)
  final bool isOngoing;
  final String skills;
  @JsonKey(includeToJson: false)
  final List<String> skillList;
  @JsonKey(includeToJson: false)
  final int starCount;
  @JsonKey(includeToJson: false)
  final bool isStarred;

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
