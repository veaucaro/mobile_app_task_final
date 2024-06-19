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
    final taskRepository = Provider.of<TaskRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks name'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter task name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_taskNameController.text.isNotEmpty) {
                    await taskRepository.addnewTask(_taskNameController.text);
                    _taskNameController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task added successfully')),
                    );
                    // Refresh the state to show the new task
                    setState(() {});
                  }
                },
                child: Text('Add Task'),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<String>>(
                future: taskRepository.FindAllTask(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No tasks found.');
                  } else {
                    return Column(
                      children: snapshot.data!.map((taskName) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(taskName),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  // 删除任务
                                  await taskRepository.deleteTask(taskName);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Task deleted successfully')),
                                  );
                                  // Refresh the state to show the updated task list
                                  setState(() {});
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
