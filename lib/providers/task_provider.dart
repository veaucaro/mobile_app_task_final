import 'package:flutter/material.dart';
import 'package:mobile_app_task_final/services/task_service.dart';
import 'package:mobile_app_task_final/services/database_service.dart';
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

  Future<void> updateNumberTaskPersonMappingInDatabase(String taskName, String personName, int newCount) async {
    PersonTask updatedTask = PersonTask(personName: personName, taskTitle: taskName, count: newCount);
    await _databaseService.insertOrUpdatePersonTask(updatedTask);
    fetchTasks();     // Refresh list after update
  }


  Future<void> updateTaskPersonMappingInDatabase(String taskName, String personName) async {
    bool found = false;
    PersonTask? personTask;

    // Search for a PersonTask corresponding to taskName and personName
    for (var task in _tasks) {
      if (task.taskTitle == taskName && task.personName == personName) {
        personTask = task;
        found = true;
        break;
      }
    }

    if (!found) {
      // If no PersonTask was found, create a new
      personTask = PersonTask(personName: personName, taskTitle: taskName, count: 1);
    } else {
      // If a PersonTask was found, increment its number
      personTask!.count++;
    }

    // Insert or update the PersonTask in the database
    await _databaseService.insertOrUpdatePersonTask(personTask);

    // Refresh Assignment List
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
