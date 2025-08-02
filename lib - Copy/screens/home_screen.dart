import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/featured_content_widget.dart';
import '../widgets/category_grid_widget.dart';
import '../widgets/recommendations_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anon Study'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Handle refresh
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SearchBarWidget(),
              ),
              
              // Featured Content
              const FeaturedContentWidget(),
              
              const SizedBox(height: 20),
              
              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 10),
              const CategoryGridWidget(),
              
              const SizedBox(height: 20),
              
              // Recommendations Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Recommended for You',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 10),
              const RecommendationsWidget(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
