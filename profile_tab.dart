// lib/screens/profile_tab.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

import '../theme/themeProvider.dart';
import 'login_screen.dart';

class ProfileTab extends StatelessWidget {
  final int checkedOutCount;
  final int favoriteCount;

  const ProfileTab({
    super.key,
    required this.checkedOutCount,
    required this.favoriteCount,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final memberSince = DateFormat('MMMM yyyy').format(user.memberSince);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(user.initials),
                  ),
                  const SizedBox(height: 16),
                  Text(user.Name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(user.Email),
                  const SizedBox(height: 16),
                  Text('Member since $memberSince'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Statistics',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                          Icons.book, 'Checked Out', '$checkedOutCount'),
                      _buildStatItem(
                          Icons.favorite, 'Favorites', '$favoriteCount'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading:
                      Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Log Out',
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    userProvider.logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}
