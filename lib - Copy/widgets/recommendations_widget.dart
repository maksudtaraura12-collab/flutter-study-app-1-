import 'package:flutter/material.dart';
import '../models/batch_model.dart';
import '../screens/batch_detail_screen.dart';

class RecommendationsWidget extends StatelessWidget {
  const RecommendationsWidget({Key? key}) : super(key: key);

  final List<BatchModel> _recommendations = const [
    BatchModel(
      id: 'r1',
      title: 'JEE Physics Crash Course',
      instructor: 'Dr. Rajesh',
      progress: 0.0,
      totalVideos: 50,
      completedVideos: 0,
      thumbnail: '/placeholder.svg?height=120&width=200&text=JEE+Physics',
      isEnrolled: false,
      price: 1999,
    ),
    BatchModel(
      id: 'r2',
      title: 'NEET Biology Complete',
      instructor: 'Prof. Priya',
      progress: 0.0,
      totalVideos: 80,
      completedVideos: 0,
      thumbnail: '/placeholder.svg?height=120&width=200&text=NEET+Biology',
      isEnrolled: false,
      price: 2499,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _recommendations.length,
        itemBuilder: (context, index) {
          final batch = _recommendations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BatchDetailScreen(batch: batch),
                ),
              );
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 16),
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
                  // Thumbnail
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      batch.thumbnail,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 120,
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          batch.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          batch.instructor,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${batch.price}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              '${batch.totalVideos} videos',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
