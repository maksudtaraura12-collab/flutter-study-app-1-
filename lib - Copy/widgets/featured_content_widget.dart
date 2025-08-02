import 'package:flutter/material.dart';

class FeaturedContentWidget extends StatefulWidget {
  const FeaturedContentWidget({Key? key}) : super(key: key);

  @override
  State<FeaturedContentWidget> createState() => _FeaturedContentWidgetState();
}

class _FeaturedContentWidgetState extends State<FeaturedContentWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _featuredContent = [
    {
      'title': 'Master Physics with Expert Teachers',
      'subtitle': 'Complete JEE & NEET Physics Course',
      'image': '/placeholder.svg?height=200&width=400&text=Physics+Course',
    },
    {
      'title': 'Advanced Mathematics Made Easy',
      'subtitle': 'From Basics to Advanced Level',
      'image': '/placeholder.svg?height=200&width=400&text=Math+Course',
    },
    {
      'title': 'Chemistry Complete Package',
      'subtitle': 'Organic, Inorganic & Physical Chemistry',
      'image': '/placeholder.svg?height=200&width=400&text=Chemistry+Course',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll featured content
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (mounted) {
      setState(() {
        _currentPage = (_currentPage + 1) % _featuredContent.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(seconds: 3), _autoScroll);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _featuredContent.length,
        itemBuilder: (context, index) {
          final content = _featuredContent[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    content['image']!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                // Overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                // Content
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content['title']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        content['subtitle']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
