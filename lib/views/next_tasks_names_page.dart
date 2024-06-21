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
  late Future<List<String>> _personsFuture;
  List<String> _persons = [];

  @override
  void initState() {
    super.initState();
    _personsFuture = _fetchPersons();
  }

  Future<List<String>> _fetchPersons() async {
    try {
      final persons = await Provider.of<TaskRepository>(context, listen: false).FindAllPerson();
      return persons;
    } catch (e) {
      print('Error loading persons: $e');
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
            icon: Icon(Icons.select_all,size: 30,),
            onPressed: () {
              if (taskProvider.selectedPerson.length == _persons.length) {
                taskProvider.clearAllPerson();
              } else {
              taskProvider.selectAllPerson(_persons);}
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
                  ' Family members',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // FutureBuilder 显示家庭成员列表
            FutureBuilder<List<String>>(
              future: _personsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No family members found.');
                } else {
                  _persons = snapshot.data!; // 更新家庭成员列表数据
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _persons.length,
                      itemBuilder: (context, index) {
                        final person = _persons[index];
                        return CheckboxListTile(
                          title: Text(person),
                          value: taskProvider.isSelectedP(person),
                          onChanged: (value) {
                            taskProvider.toggleSelectionP(person);
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
                    if (taskProvider.selectedPerson.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select at least one person.'),
                        ),
                      );
                      return;
                    }
                    else{
                    Navigator.pushNamed(context, '/page3');
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
