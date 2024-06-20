// page 2 - Find next tasks - names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../repositories/task_repository.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
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
            Text(
                  'Select your',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
            Text(
                  ' Family members',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
            SizedBox(height: 20),
            FutureBuilder<List<String>>(
              future: taskRepository.FindAllPerson(), // 替换为你的方法，获取任务列表
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
                          value: taskProvider.isSelectedP(snapshot.data![index]),
                          onChanged: (value) {
                            setState(() {
                              taskProvider.toggleSelectionP(snapshot.data![index]);
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
                    Navigator.pushNamed(context, '/page3');
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
