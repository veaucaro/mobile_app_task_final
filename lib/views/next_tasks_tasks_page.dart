// page 1 - Find next tasks - tasks
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../repositories/task_repository.dart'; // 假设你有一个 TaskProvider 来管理任务数据

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late Future<List<String>> _tasksFuture;
  List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasks();
  }

  Future<List<String>> _fetchTasks() async {
    try {
      final tasks = await Provider.of<TaskRepository>(context, listen: false).FindAllTask();
      return tasks;
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.select_all, size: 30),
            onPressed: () {
              // 实现全选逻辑
              if (taskProvider.selectedTasks.length == _tasks.length) {
                taskProvider.clearAllTasks(); // 取消全选
              } else {
                taskProvider.selectAllTasks(_tasks); // 全选
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 标题行
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
            // FutureBuilder 显示任务列表
            FutureBuilder<List<String>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No tasks found.');
                } else {
                  _tasks = snapshot.data!; // 更新任务列表数据
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
                            taskProvider.toggleSelectionT(task);
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
            // 下一步按钮
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // if didn't select any task, show a snackbar
                    if (taskProvider.selectedTasks.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select at least one task.'),
                        ),
                      );
                      return;
                    }
                    else{
                      Navigator.pushNamed(context, '/page2');
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
    );
  }
}
