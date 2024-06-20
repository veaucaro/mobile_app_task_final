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
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final taskRepository = Provider.of<TaskRepository>(context);

    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 字要粗體
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
              future: taskRepository.FindAllTask(), // 替换为你的方法，获取任务列表
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No tasks found.');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(snapshot.data![index]),
                          value: taskProvider.isSelectedT(snapshot.data![index]),
                          onChanged: (value) {
                            setState(() {
                              taskProvider.toggleSelectionT(snapshot.data![index]);
                            });
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
                    Navigator.pushNamed(context, '/page2');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, // 按钮文字颜色
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
