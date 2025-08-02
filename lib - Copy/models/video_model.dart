class VideoModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final Duration duration;
  final String instructor;
  final String batchId;
  final int order;
  final Map<String, String> qualityUrls;
  final List<String> subtitleUrls;
  final bool isPremium;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.instructor,
    required this.batchId,
    required this.order,
    this.qualityUrls = const {},
    this.subtitleUrls = const [],
    this.isPremium = false,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: Duration(seconds: json['duration'] ?? 0),
      instructor: json['instructor'] ?? '',
      batchId: json['batchId'] ?? '',
      order: json['order'] ?? 0,
      qualityUrls: Map<String, String>.from(json['qualityUrls'] ?? {}),
      subtitleUrls: List<String>.from(json['subtitleUrls'] ?? []),
      isPremium: json['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration.inSeconds,
      'instructor': instructor,
      'batchId': batchId,
      'order': order,
      'qualityUrls': qualityUrls,
      'subtitleUrls': subtitleUrls,
      'isPremium': isPremium,
    };
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
