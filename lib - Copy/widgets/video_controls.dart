import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../services/video_service.dart';

class VideoControls extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onFullscreenToggle;
  final VoidCallback onQualityTap;
  final VoidCallback onSpeedTap;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isFullscreen;

  const VideoControls({
    Key? key,
    required this.controller,
    required this.onFullscreenToggle,
    required this.onQualityTap,
    required this.onSpeedTap,
    required this.onNext,
    required this.onPrevious,
    required this.isFullscreen,
  }) : super(key: key);

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _isDragging = false;

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black54,
            Colors.transparent,
            Colors.transparent,
            Colors.black54,
          ],
        ),
      ),
      child: Column(
        children: [
          // Top Controls
          if (!widget.isFullscreen)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Consumer<VideoService>(
                      builder: (context, videoService, child) {
                        return Text(
                          videoService.currentVideo?.title ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          
          const Spacer(),
          
          // Center Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous Button
              IconButton(
                onPressed: widget.onPrevious,
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              
              // Rewind Button
              IconButton(
                onPressed: () {
                  final currentPosition = widget.controller.value.position;
                  final newPosition = currentPosition - const Duration(seconds: 10);
                  widget.controller.seekTo(
                    newPosition < Duration.zero ? Duration.zero : newPosition,
                  );
                },
                icon: const Icon(
                  Icons.replay_10,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              
              // Play/Pause Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    if (widget.controller.value.isPlaying) {
                      widget.controller.pause();
                    } else {
                      widget.controller.play();
                    }
                  },
                  icon: Icon(
                    widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              
              // Forward Button
              IconButton(
                onPressed: () {
                  final currentPosition = widget.controller.value.position;
                  final duration = widget.controller.value.duration;
                  final newPosition = currentPosition + const Duration(seconds: 10);
                  widget.controller.seekTo(
                    newPosition > duration ? duration : newPosition,
                  );
                },
                icon: const Icon(
                  Icons.forward_10,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              
              // Next Button
              IconButton(
                onPressed: widget.onNext,
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // Bottom Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Text(
                      _formatDuration(widget.controller.value.position),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Expanded(
                      child: Slider(
                        value: _isDragging
                            ? widget.controller.value.position.inSeconds.toDouble()
                            : widget.controller.value.position.inSeconds.toDouble(),
                        max: widget.controller.value.duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _isDragging = true;
                          });
                        },
                        onChangeEnd: (value) {
                          widget.controller.seekTo(Duration(seconds: value.toInt()));
                          setState(() {
                            _isDragging = false;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.white30,
                      ),
                    ),
                    Text(
                      _formatDuration(widget.controller.value.duration),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Speed Button
                        Consumer<VideoService>(
                          builder: (context, videoService, child) {
                            return TextButton(
                              onPressed: widget.onSpeedTap,
                              child: Text(
                                '${videoService.playbackSpeed}x',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                        
                        // Quality Button
                        Consumer<VideoService>(
                          builder: (context, videoService, child) {
                            return TextButton(
                              onPressed: widget.onQualityTap,
                              child: Text(
                                videoService.videoQuality,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    // Fullscreen Button
                    IconButton(
                      onPressed: widget.onFullscreenToggle,
                      icon: Icon(
                        widget.isFullscreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
