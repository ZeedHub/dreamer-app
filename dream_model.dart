import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'dream_model.freezed.dart';
part 'dream_model.g.dart';

@freezed
class DreamModel with _$DreamModel {
  const factory DreamModel({
    required String id,
    required String userId,
    required String title,
    required String content,
    @Default([]) List<String> tags,
    String? voiceNoteUrl,
    @Default('public') String privacy, // public, private, friends
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(false) bool hasInterpretation,
    String? mood, // happy, sad, fearful, excited, confused, etc.
    String? lucidity, // lucid, semi-lucid, not-lucid
    DateTime? dreamDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DreamModel;

  factory DreamModel.fromJson(Map<String, dynamic> json) =>
      _$DreamModelFromJson(json);

  factory DreamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DreamModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      voiceNoteUrl: data['voice_note_url'],
      privacy: data['privacy'] ?? 'public',
      likesCount: data['likes_count'] ?? 0,
      commentsCount: data['comments_count'] ?? 0,
      hasInterpretation: data['has_interpretation'] ?? false,
      mood: data['mood'],
      lucidity: data['lucidity'],
      dreamDate: data['dream_date'] != null
          ? (data['dream_date'] as Timestamp).toDate()
          : null,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(DreamModel dream) {
    return {
      'user_id': dream.userId,
      'title': dream.title,
      'content': dream.content,
      'tags': dream.tags,
      'voice_note_url': dream.voiceNoteUrl,
      'privacy': dream.privacy,
      'likes_count': dream.likesCount,
      'comments_count': dream.commentsCount,
      'has_interpretation': dream.hasInterpretation,
      'mood': dream.mood,
      'lucidity': dream.lucidity,
      'dream_date': dream.dreamDate != null
          ? Timestamp.fromDate(dream.dreamDate!)
          : null,
      'created_at': Timestamp.fromDate(dream.createdAt),
      'updated_at': Timestamp.fromDate(dream.updatedAt),
    };
  }
}

// Dream tags suggestions
class DreamTags {
  static const List<String> common = [
    'flying',
    'falling',
    'water',
    'animals',
    'people',
    'chase',
    'death',
    'birth',
    'travel',
    'house',
    'school',
    'work',
    'family',
    'friends',
    'love',
    'fear',
    'adventure',
    'supernatural',
    'nature',
    'city',
  ];
  
  static const List<String> emotions = [
    'happy',
    'sad',
    'anxious',
    'peaceful',
    'excited',
    'confused',
    'scared',
    'angry',
    'nostalgic',
    'hopeful',
  ];
  
  static const List<String> lucidity = [
    'lucid',
    'semi-lucid',
    'not-lucid',
  ];
}
