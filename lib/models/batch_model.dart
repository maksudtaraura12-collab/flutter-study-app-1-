import 'video_model.dart';

class BatchModel {
  final String id;
  final String title;
  final String instructor;
  final double progress;
  final int totalVideos;
  final int completedVideos;
  final String thumbnail;
  final bool isEnrolled;
  final double? price;
  final String? description;
  final List<String>? tags;
  final List<VideoModel>? videos;

  BatchModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.totalVideos,
    required this.completedVideos,
    required this.thumbnail,
    required this.isEnrolled,
    this.price,
    this.description,
    this.tags,
    this.videos,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      id: json['id'],
      title: json['title'],
      instructor: json['instructor'],
      progress: json['progress']?.toDouble() ?? 0.0,
      totalVideos: json['totalVideos'] ?? 0,
      completedVideos: json['completedVideos'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      isEnrolled: json['isEnrolled'] ?? false,
      price: json['price']?.toDouble(),
      description: json['description'],
      tags: json['tags']?.cast<String>(),
      videos: json['videos'] != null 
          ? (json['videos'] as List).map((v) => VideoModel.fromJson(v)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'progress': progress,
      'totalVideos': totalVideos,
      'completedVideos': completedVideos,
      'thumbnail': thumbnail,
      'isEnrolled': isEnrolled,
      'price': price,
      'description': description,
      'tags': tags,
      'videos': videos?.map((v) => v.toJson()).toList(),
    };
  }
}
