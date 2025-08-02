import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
// import 'package:wakelock/wakelock.dart'; // REMOVED - using built-in method
import '../services/video_service.dart';
import '../services/download_service.dart';
import '../models/video_model.dart';
import '../widgets/video_controls.dart';
import '../widgets/video_playlist_drawer.dart';
import '../widgets/video_quality_selector.dart';
import '../widgets/video_speed_selector.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<VideoModel> playlist;
  final int initialIndex;

  const VideoPlayerScreen({
    Key? key,
    required this.playlist,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isFullscreen = false;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    // Keep screen awake using built-in method
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _initializeVideoService();
  }

  void _initializeVideoService() async {
    final videoService = Provider.of<VideoService>(context, listen: false);
    await videoService.loadPlaylist(widget.playlist);
    await videoService.playVideo(widget.initialIndex);
    _initializeVideo();
  }

  void _initializeVideo() async {
    final videoService = Provider.of<VideoService>(context, listen: false);
    final downloadService = Provider.of<DownloadService>(context, listen: false);
    
    if (videoService.currentVideo == null) return;

    final video = videoService.currentVideo!;
    
    // Check if video is downloaded
    final downloadedPath = await downloadService.getDownloadedVideoPath(video.id);
    final videoUrl = downloadedPath ?? _getQualityUrl(video, videoService.videoQuality);

    _controller?.dispose();
    _controller = VideoPlayerController.network(videoUrl);
    
    setState(() {
      _isBuffering = true;
    });

    try {
      await _controller!.initialize();
      
      // Set playback speed
      await _controller!.setPlaybackSpeed(videoService.playbackSpeed);
      
      // Resume from saved position
      final savedPosition = videoService.getWatchProgress(video.id);
      if (savedPosition.inSeconds > 0) {
        await _controller!.seekTo(savedPosition);
      }
      
      // Start playing
      await _controller!.play();
      
      // Listen for position changes
      _controller!.addListener(_videoListener);
      
      setState(() {
        _isInitialized = true;
        _isBuffering = false;
      });
    } catch (e) {
      setState(() {
        _isBuffering = false;
      });
      _showError('Failed to load video: $e');
    }
  }

  String _getQualityUrl(VideoModel video, String quality) {
    return video.qualityUrls[quality] ?? video.videoUrl;
  }

  void _videoListener() {
    if (_controller == null) return;
    
    final videoService = Provider.of<VideoService>(context, listen: false);
    final video = videoService.currentVideo;
    
    if (video != null) {
      // Save progress every 5 seconds
      if (_controller!.value.position.inSeconds % 5 == 0) {
        videoService.saveWatchProgress(video.id, _controller!.value.position);
      }
      
      // Auto-play next video
      if (_controller!.value.position >= _controller!.value.duration &&
          videoService.autoPlay) {
        _playNext();
      }
    }
  }

  void _playNext() {
    final videoService = Provider.of<VideoService>(context, listen: false);
    videoService.playNext().then((_) {
      _initializeVideo();
    });
  }

  void _playPrevious() {
    final videoService = Provider.of<VideoService>(context, listen: false);
    videoService.playPrevious().then((_) {
      _initializeVideo();
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showQualitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => VideoQualitySelector(
        onQualitySelected: (quality) {
          final videoService = Provider.of<VideoService>(context, listen: false);
          videoService.setVideoQuality(quality).then((_) {
            _initializeVideo();
          });
        },
      ),
    );
  }

  void _showSpeedSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => VideoSpeedSelector(
        onSpeedSelected: (speed) {
          final videoService = Provider.of<VideoService>(context, listen: false);
          videoService.setPlaybackSpeed(speed).then((_) {
            _controller?.setPlaybackSpeed(speed);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    // Allow screen to sleep again
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen ? null : AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Consumer<VideoService>(
          builder: (context, videoService, child) {
            return Text(
              videoService.currentVideo?.title ?? 'Video Player',
              style: const TextStyle(fontSize: 16),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_play),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: VideoPlaylistDrawer(
        onVideoSelected: (index) {
          final videoService = Provider.of<VideoService>(context, listen: false);
          videoService.playVideo(index).then((_) {
            _initializeVideo();
          });
        },
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          children: [
            // Video Player
            Center(
              child: _isInitialized && _controller != null
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : _isBuffering
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(
                          Icons.error,
                          color: Colors.white,
                          size: 64,
                        ),
            ),
            
            // Video Controls
            if (_showControls && _isInitialized)
              VideoControls(
                controller: _controller!,
                onFullscreenToggle: _toggleFullscreen,
                onQualityTap: _showQualitySelector,
                onSpeedTap: _showSpeedSelector,
                onNext: _playNext,
                onPrevious: _playPrevious,
                isFullscreen: _isFullscreen,
              ),
            
            // Loading Overlay
            if (_isBuffering)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
