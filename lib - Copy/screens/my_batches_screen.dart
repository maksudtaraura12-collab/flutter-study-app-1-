import 'package:flutter/material.dart';
import '../widgets/batch_card_widget.dart';
import '../widgets/shimmer_loading.dart';
import '../models/batch_model.dart';

class MyBatchesScreen extends StatefulWidget {
  const MyBatchesScreen({Key? key}) : super(key: key);

  @override
  State<MyBatchesScreen> createState() => _MyBatchesScreenState();
}

class _MyBatchesScreenState extends State<MyBatchesScreen> {
  bool _isLoading = true;
  List<BatchModel> _batches = [];

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    // Simulate loading
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _batches = [
        BatchModel(
          id: '1',
          title: 'Physics Complete Course',
          instructor: 'Dr. Sharma',
          progress: 0.65,
          totalVideos: 120,
          completedVideos: 78,
          thumbnail: '/placeholder.svg?height=200&width=300&text=Physics',
          isEnrolled: true,
        ),
        BatchModel(
          id: '2',
          title: 'Mathematics Advanced',
          instructor: 'Prof. Kumar',
          progress: 0.45,
          totalVideos: 95,
          completedVideos: 43,
          thumbnail: '/placeholder.svg?height=200&width=300&text=Mathematics',
          isEnrolled: true,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Batches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          await _loadBatches();
        },
        child: _isLoading
            ? const ShimmerLoading()
            : _batches.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No batches enrolled yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Explore and enroll in courses',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _batches.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: BatchCardWidget(batch: _batches[index]),
                      );
                    },
                  ),
      ),
    );
  }
}
