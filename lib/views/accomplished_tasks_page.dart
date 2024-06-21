import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/providers/task_provider.dart';
import 'package:mobile_app_task_final/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class AccomplishedTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Assuming person_tasks is provided by a provider
    final personTasks = Provider.of<TaskProvider>(context);

    // Print person_tasks content to debug console
    print('Person Tasks:');
    personTasks.tasks.forEach((personTask) {
      print('Person: ${personTask.personName}, Task: ${personTask.taskTitle}, Count: ${personTask.count}');
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Accomplished Tasks'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Printed person_tasks data in debug console'),
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
