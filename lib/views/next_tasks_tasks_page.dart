import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../repositories/task_repository.dart';
import '../widgets/bottom_nav_bar.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late Future<List<String>> _tasksFuture; // Future for fetching tasks
  List<String> _tasks = []; // List to store fetched tasks

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasks(); // Initialize _tasksFuture in initState
  }

  // Method to fetch tasks from the repository
  Future<List<String>> _fetchTasks() async {
    try {
      final tasks = await Provider.of<TaskRepository>(context, listen: false).FindAllTask();
      return tasks; // Return the fetched tasks
    } catch (e) {
      print('Error loading tasks: $e'); // Handle error if fetching tasks fails
      return []; // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context); // Access TaskProvider

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back button on app bar
        actions: [
          IconButton(
            icon: Icon(Icons.select_all, size: 30),
            onPressed: () {
              if (taskProvider.selectedTasks.length == _tasks.length) {
                taskProvider.clearAllTasks(); // Clear all selected tasks if all are selected
              } else {
                taskProvider.selectAllTasks(_tasks); // Select all tasks
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select your',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' Tasks',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder<List<String>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator while fetching tasks
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Display error message if fetching fails
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      Text('No tasks found.'), // Display message if no tasks are found
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/save_task_name'); // Navigate to add task page
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: Text('Add Task'),
                      ),
                    ],
                  );
                } else {
                  _tasks = snapshot.data!; // Assign fetched tasks to _tasks list
                  return Expanded(
                    child: ListView.separated(
                      itemCount: _tasks.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return CheckboxListTile(
                          title: Text(task),
                          value: taskProvider.isSelectedT(task),
                          onChanged: (value) {
                            taskProvider.toggleSelectionT(task); // Toggle task selection
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_tasks.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No tasks found.'), // Show snackbar if no tasks are found
                        ),
                      );
                    } else if (taskProvider.selectedTasks.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select at least one task.'), // Show snackbar if no tasks are selected
                        ),
                      );
                    } else {
                      Navigator.pushNamed(context, '/page2'); // Navigate to next page
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text('Next ->'),
                ),
              ),
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
