import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/video_model.dart';

class VideoService extends ChangeNotifier {
  List<VideoModel> _playlist = [];
  int _currentVideoIndex = 0;
  double _playbackSpeed = 1.0;
  String _videoQuality = '720p';
  bool _autoPlay = true;
  Map<String, Duration> _watchProgress = {};

  List<VideoModel> get playlist => _playlist;
  int get currentVideoIndex => _currentVideoIndex;
  double get playbackSpeed => _playbackSpeed;
  String get videoQuality => _videoQuality;
  bool get autoPlay => _autoPlay;
  
  VideoModel? get currentVideo => 
      _playlist.isNotEmpty ? _playlist[_currentVideoIndex] : null;

  Future<void> loadPlaylist(List<VideoModel> videos) async {
    _playlist = videos;
    _currentVideoIndex = 0;
    await _loadWatchProgress();
    notifyListeners();
  }

  Future<void> playVideo(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentVideoIndex = index;
      notifyListeners();
    }
  }

  Future<void> playNext() async {
    if (_currentVideoIndex < _playlist.length - 1) {
      _currentVideoIndex++;
      notifyListeners();
    }
  }

  Future<void> playPrevious() async {
    if (_currentVideoIndex > 0) {
      _currentVideoIndex--;
      notifyListeners();
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('playback_speed', speed);
    notifyListeners();
  }

  Future<void> setVideoQuality(String quality) async {
    _videoQuality = quality;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('video_quality', quality);
    notifyListeners();
  }

  Future<void> setAutoPlay(bool autoPlay) async {
    _autoPlay = autoPlay;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_play', autoPlay);
    notifyListeners();
  }

  Future<void> saveWatchProgress(String videoId, Duration position) async {
    _watchProgress[videoId] = position;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('progress_$videoId', position.inSeconds);
  }

  Duration getWatchProgress(String videoId) {
    return _watchProgress[videoId] ?? Duration.zero;
  }

  Future<void> _loadWatchProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (var video in _playlist) {
      final seconds = prefs.getInt('progress_${video.id}') ?? 0;
      _watchProgress[video.id] = Duration(seconds: seconds);
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _playbackSpeed = prefs.getDouble('playback_speed') ?? 1.0;
    _videoQuality = prefs.getString('video_quality') ?? '720p';
    _autoPlay = prefs.getBool('auto_play') ?? true;
    notifyListeners();
  }
}
