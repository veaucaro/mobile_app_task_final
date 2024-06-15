import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app_task_final/repositories/task_repository.dart';
import 'package:mobile_app_task_final/services/task_service.dart';
import 'package:mobile_app_task_final/providers/task_provider.dart';
import 'package:mobile_app_task_final/views/home_page.dart';
import 'package:mobile_app_task_final/views/accomplished_tasks_page.dart';
import 'package:mobile_app_task_final/views/next_tasks_tasks_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(TaskService(TaskRepository())),
        ),
      ],
      child: MaterialApp(
        title: 'TaskRoller',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          },
      ),
    );
  }
}
