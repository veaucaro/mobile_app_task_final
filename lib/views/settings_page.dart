import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button on the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Title text style
            ),
            Text(
              ' Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo, // Text color
              ),
            ),
            SwitchListTile(
              title: Text('Dark theme'),
              value: settingsProvider.isDarkTheme,
              onChanged: (value) {
                settingsProvider.toggleDarkTheme(value);
              },
            ),
           /* // if notification in the app
              SwitchListTile(
              title: Text('Enable Notifications'),
              value: settingsProvider.areNotificationsEnabled,
              onChanged: (value) {
                settingsProvider.toggleNotifications(value);
              },
            ),
            */
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/save_task_name');
              break;
            case 2:
              Navigator.pushNamed(context, '/profiles');
              break;
          }
        },
      ),
    );
  }
}
