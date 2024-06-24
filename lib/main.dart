import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/providers/settings_provider.dart';
import 'package:mobile_app_task_final/views/existing_names_page.dart';
import 'package:mobile_app_task_final/views/existing_tasks_page.dart';
import 'package:mobile_app_task_final/views/next_tasks_find_results_page.dart';
import 'package:mobile_app_task_final/views/next_tasks_names_page.dart';
import 'package:mobile_app_task_final/views/next_tasks_tasks_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app_task_final/repositories/task_repository.dart';
import 'package:mobile_app_task_final/services/database_service.dart';
import 'package:mobile_app_task_final/services/task_service.dart';
import 'package:mobile_app_task_final/providers/task_provider.dart';
import 'package:mobile_app_task_final/views/home_page.dart';
import 'package:mobile_app_task_final/views/accomplished_tasks_page.dart';
import 'package:mobile_app_task_final/views/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  DatabaseService databaseService = DatabaseService();
  await databaseService.database;

  // Run the app
  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  MyApp({required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for TaskProvider using TaskService and TaskRepository
        ChangeNotifierProvider(
          create: (_) =>
              TaskProvider(TaskService(TaskRepository(databaseService))),
        ),
        // Provider for TaskRepository
        Provider<TaskRepository>(
          create: (_) => TaskRepository(databaseService),
        ),
        // Provider for SettingsProvider
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return MaterialApp(
              title: 'TaskRoller',
              debugShowCheckedModeBanner: false,
              theme: settingsProvider.isDarkTheme
                  ? ThemeData.dark()
                  : ThemeData.light(),
              initialRoute: '/', // Initial route set to HomePage
              routes: {
                '/': (context) => HomePage(), // home_page.dart route
                '/accomplished_tasks': (context) =>
                    AccomplishedTasksPage(), // accomplished_tasks_page.dart route
                '/save_task_name': (context) =>
                    SaveName(), // existing_tasks_page.dart route
                '/profiles': (context) =>
                    SaveFamilyName(), // existing_names_page.dart route
                '/next_tasks': (context) =>
                    Page1(), // next_tasks_tasks_page.dart route
                '/page2': (context) =>
                    Page2(), // next_tasks_names_page.dart route
                '/page3': (context) =>
                    Page3(), // next_tasks_find_results_page.dart route
                '/settings': (context) =>
                    SettingsPage(), // settings_page.dart route
              },
            );
          },
        ),
      ),
    );
  }
}
