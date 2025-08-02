import 'package:flutter/material.dart';
import '../widgets/batch_grid_card.dart';
import '../widgets/shimmer_loading.dart';
import '../models/batch_model.dart';

class OtherBatchesScreen extends StatefulWidget {
  const OtherBatchesScreen({Key? key}) : super(key: key);

  @override
  State<OtherBatchesScreen> createState() => _OtherBatchesScreenState();
}

class _OtherBatchesScreenState extends State<OtherBatchesScreen> {
  bool _isLoading = true;
  List<BatchModel> _batches = [];
  String _selectedFilter = 'All';

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
          id: '3',
          title: 'Chemistry Masterclass',
          instructor: 'Dr. Patel',
          progress: 0.0,
          totalVideos: 85,
          completedVideos: 0,
          thumbnail: '/placeholder.svg?height=200&width=300&text=Chemistry',
          isEnrolled: false,
          price: 2999,
        ),
        BatchModel(
          id: '4',
          title: 'Biology Complete',
          instructor: 'Prof. Singh',
          progress: 0.0,
          totalVideos: 110,
          completedVideos: 0,
          thumbnail: '/placeholder.svg?height=200&width=300&text=Biology',
          isEnrolled: false,
          price: 3499,
        ),
        BatchModel(
          id: '5',
          title: 'English Grammar',
          instructor: 'Ms. Gupta',
          progress: 0.0,
          totalVideos: 60,
          completedVideos: 0,
          thumbnail: '/placeholder.svg?height=200&width=300&text=English',
          isEnrolled: false,
          price: 1999,
        ),
        BatchModel(
          id: '6',
          title: 'Computer Science',
          instructor: 'Mr. Verma',
          progress: 0.0,
          totalVideos: 150,
          completedVideos: 0,
          thumbnail: '/placeholder.svg?height=200&width=300&text=Computer',
          isEnrolled: false,
          price: 4999,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Batches'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All')),
              const PopupMenuItem(value: 'Physics', child: Text('Physics')),
              const PopupMenuItem(value: 'Chemistry', child: Text('Chemistry')),
              const PopupMenuItem(value: 'Mathematics', child: Text('Mathematics')),
              const PopupMenuItem(value: 'Biology', child: Text('Biology')),
            ],
            child: const Icon(Icons.filter_list),
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
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _batches.length,
                itemBuilder: (context, index) {
                  return BatchGridCard(batch: _batches[index]);
                },
              ),
      ),
    );
  }
}
