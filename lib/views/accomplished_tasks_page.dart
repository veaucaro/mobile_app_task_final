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
      future: taskProvider.getPersonTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingUI();
        } else if (snapshot.hasError) {
          return buildErrorUI(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildNoTasksUI();
        } else {
          final tasks = snapshot.data!;
          final groupedTasks = _groupTasks(tasks);

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: buildTasksList(groupedTasks),
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

  Widget buildLoadingUI() {
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

          // Handle bottom nav bar taps
        },
      ),
    );
  }

  Widget buildErrorUI(String error) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Error loading tasks: $error'),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle bottom nav bar taps
        },
      ),
    );
  }

  Widget buildNoTasksUI() {
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
          // Handle bottom nav bar taps
        },
      ),
    );
  }

  Widget buildTasksList(Map<String, List<PersonTask>> groupedTasks) {
    return Column(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        personName,
                        textAlign: TextAlign.center, // Center the person's name
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      ...personTasks.map((task) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${task.taskTitle} = ${task.count} times',
                              style: TextStyle(fontSize: 16),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  showEditDialog(context, task);
                                },
                                child: Text('Edit'),
                              ),
                            ),
                          ],
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
    );
  }

  void showEditDialog(BuildContext context, PersonTask task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newCount = task.count;

        return AlertDialog(
          title: Text('Edit Task Count'),
          content: TextFormField(
            initialValue: task.count.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newCount = int.tryParse(value) ?? task.count;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                if (newCount != task.count) {
                  task.count = newCount;
                  await Provider.of<TaskProvider>(context, listen: false)
                      .updateNumberTaskPersonMappingInDatabase(
                      task.taskTitle, task.personName, newCount);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Map<String, List<PersonTask>> _groupTasks(List<PersonTask> tasks) {
    final Map<String, List<PersonTask>> groupedTasks = {};

    for (var task in tasks) {
      if (!groupedTasks.containsKey(task.personName)) {
        groupedTasks[task.personName] = [];
      }
      groupedTasks[task.personName]!.add(task);
    }

    return groupedTasks;
  }
}
