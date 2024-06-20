import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/widgets/bottom_nav_bar.dart';

class AccomplishedTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accomplished Tasks'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Stg'),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
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
