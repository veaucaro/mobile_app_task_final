import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app_task_final/providers/task_provider.dart';
import 'package:mobile_app_task_final/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Use a Future to ensure fetchTasks is called after the first build
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF7D50FF), // Background color of the scaffold
      appBar: AppBar(
        backgroundColor: Color(0xFF7D50FF),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          )
        ],
        automaticallyImplyLeading: false, // Disable the back button on the app bar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon1.png', height: 200), // Display an image from assets
            SizedBox(height: 20),
            Text('Welcome', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), // Welcome text
            Text('Family', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)), // Family text
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/accomplished_tasks'); // Navigate to accomplished tasks page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Button background color
              ),
              child: Text(
                'Accomplished tasks',
                style: TextStyle(
                  color: Colors.white, // Button text color
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/next_tasks'); // Navigate to next tasks page
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white, // Button text and background color
              ),
              child: Text('Find your next tasks'), // Button text
            ),
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
