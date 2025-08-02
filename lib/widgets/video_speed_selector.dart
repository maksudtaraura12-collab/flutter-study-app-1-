import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/video_service.dart';

class VideoSpeedSelector extends StatelessWidget {
  final Function(double) onSpeedSelected;

  const VideoSpeedSelector({
    Key? key,
    required this.onSpeedSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Playback Speed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<VideoService>(
            builder: (context, videoService, child) {
              return Column(
                children: speeds.map((speed) {
                  final isSelected = videoService.playbackSpeed == speed;
                  return ListTile(
                    title: Text('${speed}x'),
                    trailing: isSelected 
                        ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                        : null,
                    onTap: () {
                      onSpeedSelected(speed);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
