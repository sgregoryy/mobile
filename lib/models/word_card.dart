import 'package:hive/hive.dart';

part 'word_card.g.dart';

// models/word_card.dart
@HiveType(typeId: 0)
class WordCard extends HiveObject {
  @HiveField(0)
  final String word;

  @HiveField(1)
  final String translation;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime lastReviewed;

  @HiveField(4)
  int correctAnswers;

  WordCard({
    required this.word,
    required this.translation,
    required this.category,
    DateTime? lastReviewed,
    this.correctAnswers = 0,
  }) : this.lastReviewed = lastReviewed ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'word': word,
    'translation': translation,
    'category': category,
    'lastReviewed': lastReviewed.toIso8601String(),
    'correctAnswers': correctAnswers,
  };

  factory WordCard.fromJson(Map<String, dynamic> json) => WordCard(
    word: json['word'] as String,
    translation: json['translation'] as String,
    category: json['category'] as String,
    lastReviewed: DateTime.parse(json['lastReviewed'] as String),
    correctAnswers: json['correctAnswers'] as int? ?? 0,
  );
}