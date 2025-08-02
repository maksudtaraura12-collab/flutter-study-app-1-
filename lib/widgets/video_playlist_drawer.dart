import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/video_service.dart';
import '../services/download_service.dart';

class VideoPlaylistDrawer extends StatelessWidget {
  final Function(int) onVideoSelected;

  const VideoPlaylistDrawer({
    Key? key,
    required this.onVideoSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.playlist_play, color: Colors.white, size: 32),
                SizedBox(width: 16),
                Text(
                  'Playlist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer2<VideoService, DownloadService>(
              builder: (context, videoService, downloadService, child) {
                final playlist = videoService.playlist;
                final currentIndex = videoService.currentVideoIndex;
                
                return ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final video = playlist[index];
                    final isCurrentVideo = index == currentIndex;
                    final isDownloaded = downloadService.isDownloaded(video.id);
                    final isDownloading = downloadService.isDownloading(video.id);
                    final downloadProgress = downloadService.downloadProgress[video.id];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: isCurrentVideo 
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                      child: ListTile(
                        leading: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                video.thumbnailUrl,
                                width: 60,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 40,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.play_circle_outline),
                                  );
                                },
                              ),
                            ),
                            if (isCurrentVideo)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          video.title,
                          style: TextStyle(
                            fontWeight: isCurrentVideo ? FontWeight.bold : FontWeight.normal,
                            color: isCurrentVideo ? Theme.of(context).primaryColor : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.formattedDuration,
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (isDownloading && downloadProgress != null)
                              LinearProgressIndicator(
                                value: downloadProgress,
                                backgroundColor: Colors.grey[300],
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (video.isPremium)
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            if (isDownloaded)
                              const Icon(
                                Icons.download_done,
                                color: Colors.green,
                                size: 16,
                              ),
                            if (isDownloading)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                if (!isDownloaded && !isDownloading)
                                  PopupMenuItem(
                                    value: 'download',
                                    child: const Row(
                                      children: [
                                        Icon(Icons.download),
                                        SizedBox(width: 8),
                                        Text('Download'),
                                      ],
                                    ),
                                  ),
                                if (isDownloaded)
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: const Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete Download'),
                                      ],
                                    ),
                                  ),
                              ],
                              onSelected: (value) async {
                                if (value == 'download') {
                                  try {
                                    await downloadService.downloadVideo(video);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Download started'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Download failed: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else if (value == 'delete') {
                                  await downloadService.deleteDownload(video.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Download deleted'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          onVideoSelected(index);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
