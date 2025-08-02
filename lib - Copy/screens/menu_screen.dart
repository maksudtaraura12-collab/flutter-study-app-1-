import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/theme_service.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'student@example.com',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Handle profile edit
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Menu Items
          _buildMenuSection(
            context,
            'Settings',
            [
              _buildMenuItem(
                context,
                Icons.dark_mode,
                'Dark Mode',
                trailing: Consumer<ThemeService>(
                  builder: (context, themeService, child) {
                    return Switch(
                      value: themeService.isDarkMode,
                      onChanged: (value) {
                        themeService.toggleTheme();
                      },
                    );
                  },
                ),
              ),
              _buildMenuItem(
                context,
                Icons.notifications,
                'Notifications',
                onTap: () {
                  // Handle notifications settings
                },
              ),
              _buildMenuItem(
                context,
                Icons.download,
                'Downloads',
                onTap: () {
                  // Handle downloads
                },
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildMenuSection(
            context,
            'Support',
            [
              _buildMenuItem(
                context,
                Icons.share,
                'Share App',
                onTap: () {
                  Share.share(
                    'Check out Anon Study - Premium Learning Experience!\n'
                    'Download now: https://play.google.com/store/apps/details?id=com.anonstudy.app',
                  );
                },
              ),
              _buildMenuItem(
                context,
                Icons.telegram,
                'Join Telegram',
                onTap: () async {
                  const url = 'https://t.me/anonstudy';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
              ),
              _buildMenuItem(
                context,
                Icons.info,
                'About',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Anon Study',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(Icons.school),
                    children: [
                      const Text('Premium Learning Experience'),
                      const Text('Complete Ed-Tech App with Video Player, PDF Viewer, Downloads & Analytics'),
                    ],
                  );
                },
              ),
              _buildMenuItem(
                context,
                Icons.description,
                'Disclaimer',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Disclaimer'),
                      content: const Text(
                        'This app is for educational purposes only. '
                        'All content is provided by respective instructors. '
                        'We do not claim ownership of any educational material.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
