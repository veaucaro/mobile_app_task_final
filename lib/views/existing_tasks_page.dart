import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/task_repository.dart';
import '../widgets/bottom_nav_bar.dart';

class SaveName extends StatefulWidget {
  @override
  _SaveNameState createState() => _SaveNameState();
}

class _SaveNameState extends State<SaveName> {
  final TextEditingController _taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskRepository = Provider.of<TaskRepository>(context); // Access the TaskRepository instance using Provider

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button on the app bar
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Title text style
              ),
              Text(
                ' Tasks',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo, // Text color
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter task name', // Input field label
                    border: OutlineInputBorder(), // Border around the input field
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_taskNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a task name')), // Show a snackbar if the input field is empty
                    );
                  } else {
                    await taskRepository.addnewTask(_taskNameController.text); // Add the new task using the task repository
                    _taskNameController.clear(); // Clear the text input field
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task added successfully')), // Show a snackbar after successfully adding the task
                    );
                    // Refresh the state to display the new task in the list
                    setState(() {});
                  }
                },
                child: Text('Add Task'), // Button text
              ),
              SizedBox(height: 20),
              FutureBuilder<List<String>>(
                future: taskRepository.FindAllTask(), // Fetch all tasks from the task repository
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while fetching data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Show an error message if fetching data fails
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No tasks found.'); // Display message if no tasks are found
                  } else {
                    return Column(
                      children: snapshot.data!.map((taskName) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Card(
                            elevation: 2, // Card elevation
                            child: ListTile(
                              title: Text(taskName), // Task name displayed in a list tile
                              trailing: IconButton(
                                icon: Icon(Icons.delete), // Delete icon button
                                onPressed: () async {
                                  await taskRepository.deleteTask(taskName); // Delete task from repository
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Task deleted successfully')), // Show a snackbar after deleting the task
                                  );
                                  setState(() {}); // Refresh the state to update the task list
                                },
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
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
