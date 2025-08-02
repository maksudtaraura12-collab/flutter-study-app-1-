import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/batch_model.dart';
import '../models/video_model.dart';
import '../services/download_service.dart';
import 'video_player_screen.dart';

class BatchDetailScreen extends StatefulWidget {
  final BatchModel batch;

  const BatchDetailScreen({Key? key, required this.batch}) : super(key: key);

  @override
  State<BatchDetailScreen> createState() => _BatchDetailScreenState();
}

class _BatchDetailScreenState extends State<BatchDetailScreen> {
  List<VideoModel> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    // Simulate loading videos from API
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _videos = [
        VideoModel(
          id: '${widget.batch.id}_1',
          title: 'Introduction to ${widget.batch.title}',
          description: 'Welcome to the complete course on ${widget.batch.title}',
          videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          thumbnailUrl: '/placeholder.svg?height=200&width=300&text=Video+1',
          duration: const Duration(minutes: 15, seconds: 30),
          instructor: widget.batch.instructor,
          batchId: widget.batch.id,
          order: 1,
          qualityUrls: {
            '240p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            '360p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            '480p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          },
        ),
        VideoModel(
          id: '${widget.batch.id}_2',
          title: 'Chapter 1: Fundamentals',
          description: 'Learn the basic concepts and fundamentals',
          videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          thumbnailUrl: '/placeholder.svg?height=200&width=300&text=Video+2',
          duration: const Duration(minutes: 25, seconds: 45),
          instructor: widget.batch.instructor,
          batchId: widget.batch.id,
          order: 2,
          qualityUrls: {
            '240p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
            '360p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
            '480p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
            '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
            '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          },
        ),
        VideoModel(
          id: '${widget.batch.id}_3',
          title: 'Chapter 2: Advanced Topics',
          description: 'Dive deep into advanced concepts',
          videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          thumbnailUrl: '/placeholder.svg?height=200&width=300&text=Video+3',
          duration: const Duration(minutes: 35, seconds: 20),
          instructor: widget.batch.instructor,
          batchId: widget.batch.id,
          order: 3,
          isPremium: true,
          qualityUrls: {
            '240p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
            '360p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
            '480p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
            '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
            '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          },
        ),
      ];
      _isLoading = false;
    });
  }

  void _playVideo(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          playlist: _videos,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.batch.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Batch Header
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.batch.thumbnail),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) {},
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.batch.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'By ${widget.batch.instructor}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.play_circle, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.batch.totalVideos} Videos',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(width: 16),
                              if (widget.batch.price != null) ...[
                                const Icon(Icons.currency_rupee, color: Colors.white, size: 16),
                                Text(
                                  '${widget.batch.price}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Progress Section (if enrolled)
                  if (widget.batch.isEnrolled)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your Progress',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${(widget.batch.progress * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: widget.batch.progress,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.batch.completedVideos} of ${widget.batch.totalVideos} videos completed',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  
                  // Videos List
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Course Content',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _videos.length,
                          itemBuilder: (context, index) {
                            final video = _videos[index];
                            return Consumer<DownloadService>(
                              builder: (context, downloadService, child) {
                                final isDownloaded = downloadService.isDownloaded(video.id);
                                final isDownloading = downloadService.isDownloading(video.id);
                                final downloadProgress = downloadService.downloadProgress[video.id];
                                
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: ListTile(
                                    leading: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            video.thumbnailUrl,
                                            width: 80,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 80,
                                                height: 60,
                                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                                child: Icon(
                                                  Icons.play_circle_outline,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            video.title,
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (video.isPremium)
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                      ],
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
                                        if (isDownloaded)
                                          const Icon(
                                            Icons.download_done,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        if (isDownloading)
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
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
                                    onTap: () => _playVideo(index),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
