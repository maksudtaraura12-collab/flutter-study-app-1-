import 'package:flutter/material.dart';

class CategoryGridWidget extends StatelessWidget {
  const CategoryGridWidget({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _categories = const [
    {
      'title': 'Physics',
      'icon': Icons.science,
      'color': Color(0xFF4CAF50),
      'count': '120+ Courses',
    },
    {
      'title': 'Mathematics',
      'icon': Icons.calculate,
      'color': Color(0xFF2196F3),
      'count': '95+ Courses',
    },
    {
      'title': 'Chemistry',
      'icon': Icons.biotech,
      'color': Color(0xFFFF9800),
      'count': '85+ Courses',
    },
    {
      'title': 'Biology',
      'icon': Icons.local_florist,
      'color': Color(0xFF8BC34A),
      'count': '110+ Courses',
    },
    {
      'title': 'English',
      'icon': Icons.language,
      'color': Color(0xFF9C27B0),
      'count': '60+ Courses',
    },
    {
      'title': 'Computer',
      'icon': Icons.computer,
      'color': Color(0xFF607D8B),
      'count': '150+ Courses',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return GestureDetector(
            onTap: () {
              // Handle category tap
              print('Tapped on ${category['title']}');
            },
            child: Container(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category['icon'],
                      size: 30,
                      color: category['color'],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category['count'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
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
