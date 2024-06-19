import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/views/existing_names_page.dart';
import 'package:mobile_app_task_final/views/existing_tasks_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app_task_final/repositories/task_repository.dart';
import 'package:mobile_app_task_final/services/database_service.dart';
import 'package:mobile_app_task_final/services/task_service.dart';
import 'package:mobile_app_task_final/providers/task_provider.dart';
import 'package:mobile_app_task_final/views/home_page.dart';
import 'package:mobile_app_task_final/views/accomplished_tasks_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化資料庫
  DatabaseService databaseService = DatabaseService();

  await databaseService.database;

  runApp(MyApp(databaseService: databaseService));
}


class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  MyApp({required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(TaskService(TaskRepository(databaseService))),
        ),
        Provider<TaskRepository>(
          create: (_) => TaskRepository(databaseService),
        ),
      ],
      child: SafeArea(
        child: MaterialApp(
          title: 'TaskRoller',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/accomplished_tasks': (context) => AccomplishedTasksPage(),
            '/save_task_name': (context) => SaveName(),
            '/profiles': (context) => SaveFamilyName(),
          },
        ),
      ),
    );
  }
}
