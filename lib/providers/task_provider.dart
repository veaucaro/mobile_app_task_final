import 'package:flutter/material.dart'; // Import Flutter Material package
import 'package:mobile_app_task_final/services/task_service.dart'; // Import TaskService for business logic
import 'package:mobile_app_task_final/services/database_service.dart'; // Import DatabaseService for database operations
import 'package:mobile_app_task_final/models/person.dart'; // Import PersonTask model

class TaskProvider with ChangeNotifier {
  final TaskService service; // Instance of TaskService to handle business logic

  TaskProvider(this.service); // Constructor to initialize with TaskService instance

  List<PersonTask> _tasks = []; // List to store fetched tasks
  List<PersonTask> get tasks => _tasks; // Getter for tasks

  // Fetch tasks from service and notify listeners
  Future<void> fetchTasks() async {
    _tasks = await service.getTasks();
    notifyListeners();
  }

  DatabaseService _databaseService = DatabaseService(); // Instance of DatabaseService for direct database operations

  // Fetch all PersonTasks from the database
  Future<List<PersonTask>> getPersonTasks() async {
    return await _databaseService.personTasks();
  }

  List<String> _selectedTasks = []; // List to store selected task names
  List<String> _selectedPerson = []; // List to store selected person names

  List<String> get selectedTasks => _selectedTasks; // Getter for selected task names
  List<String> get selectedPerson => _selectedPerson; // Getter for selected person names

  // Check if a task name is selected
  bool isSelectedT(String taskName) {
    return _selectedTasks.contains(taskName);
  }

  // Check if a person name is selected
  bool isSelectedP(String personName) {
    return _selectedPerson.contains(personName);
  }

  // Toggle selection of a task name
  void toggleSelectionT(String taskName) {
    if (_selectedTasks.contains(taskName)) {
      _selectedTasks.remove(taskName);
    } else {
      _selectedTasks.add(taskName);
    }
    notifyListeners();
  }

  // Update the count of tasks assigned to a person in the database
  Future<void> updateNumberTaskPersonMappingInDatabase(String taskName, String personName, int newCount) async {
    PersonTask updatedTask = PersonTask(personName: personName, taskTitle: taskName, count: newCount);
    await _databaseService.insertOrUpdatePersonTask(updatedTask);
    fetchTasks(); // Refresh task list after update
  }

  // Assign or increment a task for a person in the database
  Future<void> updateTaskPersonMappingInDatabase(String taskName, String personName) async {
    bool found = false;
    PersonTask? personTask;

    // Search for existing PersonTask corresponding to taskName and personName
    for (var task in _tasks) {
      if (task.taskTitle == taskName && task.personName == personName) {
        personTask = task;
        found = true;
        break;
      }
    }

    if (!found) {
      // If no PersonTask was found, create a new one
      personTask = PersonTask(personName: personName, taskTitle: taskName, count: 1);
    } else {
      // If a PersonTask was found, increment its count
      personTask!.count++;
    }

    // Insert or update the PersonTask in the database
    await _databaseService.insertOrUpdatePersonTask(personTask);

    // Refresh task list
    fetchTasks();
  }

  // Toggle selection of a person name
  void toggleSelectionP(String personName) {
    if (_selectedPerson.contains(personName)) {
      _selectedPerson.remove(personName);
    } else {
      _selectedPerson.add(personName);
    }
    notifyListeners();
  }

  // Clear all selected tasks and persons
  void clearSelections() {
    _selectedTasks.clear();
    _selectedPerson.clear();
    notifyListeners();
  }

  // Select all tasks
  void selectAllTasks(List<String> tasks) {
    _selectedTasks = List.from(tasks);
    notifyListeners();
  }

  // Select all persons
  void selectAllPerson(List<String> persons) {
    _selectedPerson = List.from(persons);
    notifyListeners();
  }

  // Clear selected persons
  void clearAllPerson() {
    _selectedPerson.clear();
    notifyListeners();
  }

  // Clear selected tasks
  void clearAllTasks() {
    _selectedTasks.clear();
    notifyListeners();
  }

  Future<void> deleteTask(String taskTitle, String personName) async {
    await _databaseService.deletePersonTask(taskTitle, personName);
    fetchTasks();
  }
}
