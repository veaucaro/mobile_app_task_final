import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/providers/task_provider.dart';
import 'package:mobile_app_task_final/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app_task_final/models/person.dart';

class AccomplishedTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context); // Access the TaskProvider instance using Provider

    return FutureBuilder<List<PersonTask>>(
      future: taskProvider.getPersonTasks(), // Fetch list of accomplished tasks asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingUI(context); // Show loading UI while fetching tasks
        } else if (snapshot.hasError) {
          return buildErrorUI(context, snapshot.error.toString()); // Show error UI if fetching tasks fails
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildNoTasksUI(context); // Show UI indicating no tasks are accomplished yet
        } else {
          final tasks = snapshot.data!; // Extract fetched tasks
          final groupedTasks = _groupTasks(tasks); // Group tasks by person's name

          return Scaffold(
            appBar: AppBar(
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
            body: buildTasksList(groupedTasks), // Show the list of grouped tasks
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

  // Widget for showing loading UI
  Widget buildLoadingUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button on the app bar
      ),
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator in the center of the screen
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

  // Widget for showing error UI
  Widget buildErrorUI(BuildContext context, String error) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button on the app bar
      ),
      body: Center(
        child: Text('Error loading tasks: $error'), // Display error message in the center of the screen
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

  // Widget for showing UI when no tasks are available
  Widget buildNoTasksUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button on the app bar
      ),
      body: Center(
        child: Text('No tasks accomplished yet.'), // Display message indicating no tasks are accomplished yet
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

  // Widget for building the list of grouped tasks
  Widget buildTasksList(Map<String, List<PersonTask>> groupedTasks) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Accomplished',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Title text style
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 16.0),
          child: Text(
            'Tasks',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.indigo, // Text color
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: groupedTasks.length,
            itemBuilder: (context, index) {
              final personName = groupedTasks.keys.elementAt(index); // Get person's name at current index
              final personTasks = groupedTasks[personName]!; // Get tasks associated with the person

              return Card(
                margin: EdgeInsets.all(10), // Card margin
                child: Padding(
                  padding: EdgeInsets.all(10), // Padding inside the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        personName,
                        textAlign: TextAlign.center, // Center the person's name
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo, // Person's name text style
                        ),
                      ),
                      ...personTasks.map((task) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${task.taskTitle} = ${task.count} times', // Display task title and count
                              style: TextStyle(fontSize: 16), // Task text style
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  showEditDialog(context, task); // Show dialog for editing task count
                                },
                                child: Text('Edit'), // Button text
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

  // Function to show edit dialog for task count
  void showEditDialog(BuildContext context, PersonTask task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newCount = task.count; // Initialize new count with current task count

        return AlertDialog(
          title: Text('Edit Task Count'), // Dialog title
          content: TextFormField(
            initialValue: task.count.toString(), // Initial value of text field
            keyboardType: TextInputType.number, // Keyboard type for numeric input
            onChanged: (value) {
              newCount = int.tryParse(value) ?? task.count; // Parse and update new count
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'), // Cancel button text
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            TextButton(
              child: Text('Update'), // Update button text
              onPressed: () async {
                if (newCount != task.count) {
                  task.count = newCount; // Update task count
                  await Provider.of<TaskProvider>(context, listen: false)
                      .updateNumberTaskPersonMappingInDatabase(
                      task.taskTitle, task.personName, newCount); // Update task count in database
                  Navigator.of(context).pop(); // Dismiss dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to group tasks by person's name
  Map<String, List<PersonTask>> _groupTasks(List<PersonTask> tasks) {
    final Map<String, List<PersonTask>> groupedTasks = {};

    for (var task in tasks) {
      if (!groupedTasks.containsKey(task.personName)) {
        groupedTasks[task.personName] = []; // Initialize list for person's tasks
      }
      groupedTasks[task.personName]!.add(task); // Add task to person's task list
    }

    return groupedTasks; // Return grouped tasks
  }
}
