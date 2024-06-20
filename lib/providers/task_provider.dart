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

  List<String> _selectedTasks = [];
  List<String> _selectedPerson= [];

  List<String> get selectedTasks => _selectedTasks;
  List<String> get selectedPerson => _selectedPerson;

  bool isSelectedT(String taskName) {
    return _selectedTasks.contains(taskName);
  }
  bool isSelectedP(String personName) {
    return _selectedPerson.contains(personName);
  }
  void toggleSelectionT(String taskName) {
    if (_selectedTasks.contains(taskName)) {
      _selectedTasks.remove(taskName);
    } else {
      _selectedTasks.add(taskName);
    }
    notifyListeners();
  }
  void toggleSelectionP(String personName) {
    if (_selectedPerson.contains(personName)) {
      _selectedPerson.remove(personName);
    } else {
      _selectedPerson.add(personName);
    }
    notifyListeners();
  }
  //Find all tasks
}
