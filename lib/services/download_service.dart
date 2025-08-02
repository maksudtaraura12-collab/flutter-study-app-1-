import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../models/video_model.dart';

class DownloadService extends ChangeNotifier {
  final Dio _dio = Dio();
  Map<String, double> _downloadProgress = {};
  List<String> _downloadingVideos = [];
  List<String> _downloadedVideos = [];

  Map<String, double> get downloadProgress => _downloadProgress;
  List<String> get downloadingVideos => _downloadingVideos;
  List<String> get downloadedVideos => _downloadedVideos;

  bool isDownloading(String videoId) => _downloadingVideos.contains(videoId);
  bool isDownloaded(String videoId) => _downloadedVideos.contains(videoId);

  Future<bool> requestPermissions() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> downloadVideo(VideoModel video) async {
    if (_downloadingVideos.contains(video.id)) return;

    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }

    _downloadingVideos.add(video.id);
    _downloadProgress[video.id] = 0.0;
    notifyListeners();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final videoDir = Directory('${directory.path}/videos');
      if (!await videoDir.exists()) {
        await videoDir.create(recursive: true);
      }

      final filePath = '${videoDir.path}/${video.id}.mp4';

      await _dio.download(
        video.videoUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _downloadProgress[video.id] = received / total;
            notifyListeners();
          }
        },
      );

      _downloadingVideos.remove(video.id);
      _downloadedVideos.add(video.id);
      _downloadProgress.remove(video.id);
      notifyListeners();

    } catch (e) {
      _downloadingVideos.remove(video.id);
      _downloadProgress.remove(video.id);
      notifyListeners();
      throw Exception('Download failed: $e');
    }
  }

  Future<void> deleteDownload(String videoId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/videos/$videoId.mp4';
      final file = File(filePath);
      
      if (await file.exists()) {
        await file.delete();
        _downloadedVideos.remove(videoId);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }

  Future<String?> getDownloadedVideoPath(String videoId) async {
    if (!_downloadedVideos.contains(videoId)) return null;
    
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/videos/$videoId.mp4';
    final file = File(filePath);
    
    if (await file.exists()) {
      return filePath;
    }
    return null;
  }

  Future<void> loadDownloadedVideos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final videoDir = Directory('${directory.path}/videos');
      
      if (await videoDir.exists()) {
        final files = await videoDir.list().toList();
        _downloadedVideos = files
            .where((file) => file.path.endsWith('.mp4'))
            .map((file) => file.path.split('/').last.replaceAll('.mp4', ''))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading downloaded videos: $e');
    }
  }
}
