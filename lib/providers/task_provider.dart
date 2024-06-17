// providers/task_provider.dart
import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/services/task_service.dart';
import 'package:mobile_app_task_final/models/person.dart';

class TaskProvider with ChangeNotifier {
  final TaskService service;

  TaskProvider(this.service);

  List<PersonTask> _tasks = [];

  List<PersonTask> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await service.getTasks();
    notifyListeners();
  }

  Future<void> addTask(PersonTask personTask) async {
    await service.addTask(personTask);
    fetchTasks();
  }
}
