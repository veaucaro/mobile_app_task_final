import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/services/task_service.dart';
import 'package:mobile_app_task_final/models/task.dart';

class TaskProvider with ChangeNotifier {
  final TaskService service;

  TaskProvider(this.service);

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void fetchTasks() {
    _tasks = service.getTasks();
    notifyListeners();
  }
}
