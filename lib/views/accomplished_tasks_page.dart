import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/providers/task_provider.dart';
import 'package:mobile_app_task_final/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app_task_final/models/person.dart';

class AccomplishedTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return FutureBuilder<List<PersonTask>>(
      future: taskProvider.getPersonTasks(), // Assume this method fetches person tasks from the database
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: CircularProgressIndicator(),

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
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Text('Error loading tasks: ${snapshot.error}'),
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
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Text('No tasks accomplished yet.'),
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
        } else {
          final tasks = snapshot.data!;
          final Map<String, List<PersonTask>> groupedTasks = {};

          for (var task in tasks) {
            if (!groupedTasks.containsKey(task.personName)) {
              groupedTasks[task.personName] = [];
            }
            groupedTasks[task.personName]!.add(task);
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Accomplished',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 16.0),
                  child: Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedTasks.length,
                    itemBuilder: (context, index) {
                      final personName = groupedTasks.keys.elementAt(index);
                      final personTasks = groupedTasks[personName]!;

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                personName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...personTasks.map((task) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  '${task.taskTitle} = ${task.count} times',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
      },
    );
  }
}
