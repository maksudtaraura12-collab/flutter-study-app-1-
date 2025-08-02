import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/video_service.dart';

class VideoQualitySelector extends StatelessWidget {
  final Function(String) onQualitySelected;

  const VideoQualitySelector({
    Key? key,
    required this.onQualitySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qualities = ['240p', '360p', '480p', '720p', '1080p'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Video Quality',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<VideoService>(
            builder: (context, videoService, child) {
              return Column(
                children: qualities.map((quality) {
                  final isSelected = videoService.videoQuality == quality;
                  return ListTile(
                    title: Text(quality),
                    trailing: isSelected 
                        ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                        : null,
                    onTap: () {
                      onQualitySelected(quality);
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
