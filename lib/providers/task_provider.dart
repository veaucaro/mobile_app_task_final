// providers/task_provider.dart
import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/services/task_service.dart';
import 'package:mobile_app_task_final/services/database_service.dart'; // Ajouté
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

  Future<void> update(PersonTask personTask) async {
    await service.update(personTask);
    fetchTasks();
  }

  // Ajouté
  DatabaseService _databaseService = DatabaseService();

  Future<List<PersonTask>> getPersonTasks() async {
    return await _databaseService.personTasks();
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

  void updateTaskPersonMappingInDatabase(String taskName, String personName) async {
    // Find the personTask object, if it exists, increment the count by 1, if it does not exist, create a new object
    PersonTask? personTask = _tasks.firstWhere(
          (element) => element.taskTitle == taskName && element.personName == personName,
      orElse: () => PersonTask(personName: personName, taskTitle: taskName, count: 0),
    );

    if (personTask.personName == null) {
      await service.update(personTask);
    } else {
      personTask.count += 1;
      await service.update(personTask);
    }

    // Update the database as well
    await _databaseService.insertPersonTask(personTask);
    fetchTasks();
  }

  void toggleSelectionP(String personName) {
    if (_selectedPerson.contains(personName)) {
      _selectedPerson.remove(personName);
    } else {
      _selectedPerson.add(personName);
    }
    notifyListeners();
  }

  // Find all tasks
  void clearSelections() {
    _selectedTasks.clear();
    _selectedPerson.clear();
    notifyListeners();
  }

  void selectAllTasks(List<String> tasks) {
    _selectedTasks = List.from(tasks);
    notifyListeners();
  }

  void selectAllPerson(List<String> persons) {
    _selectedPerson = List.from(persons);
    notifyListeners();
  }

  void clearAllPerson() {
    _selectedPerson.clear();
    notifyListeners();
  }

  void clearAllTasks() {
    _selectedTasks.clear();
    notifyListeners();
  }
}
