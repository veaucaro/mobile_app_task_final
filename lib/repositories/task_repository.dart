import 'package:mobile_app_task_final/models/person.dart'; // Import PersonTask model
import 'package:mobile_app_task_final/services/database_service.dart'; // Import DatabaseService for database operations

class TaskRepository {
  final DatabaseService _databaseService; // Database service instance

  TaskRepository(this._databaseService); // Constructor to initialize with DatabaseService instance

  // Fetch all tasks from the database
  Future<List<PersonTask>> fetchTasks() async {
    return await _databaseService.personTasks();
  }

  // Retrieve all task names from the database
  Future<List<String>> FindAllTask() async {
    return await _databaseService.queryTasks();
  }

  // Retrieve all person names from the database
  Future<List<String>> FindAllPerson() async {
    return await _databaseService.queryPersons();
  }

  // Update a person's task details in the database
  Future<void> update(PersonTask personTask) async {
    await _databaseService.insertOrUpdatePersonTask(personTask);
  }

  // Add a new task name to the database
  Future<void> addnewTask(String taskName) async {
    await _databaseService.insertTaskName(taskName);
  }

  // Add a new person name to the database
  Future<void> addnewPerson(String personName) async {
    await _databaseService.insertPersonName(personName);
  }

  // Delete a task from the database
  Future<void> deleteTask(String name) async {
    await _databaseService.deleteTask(name);
  }

  // Delete a person from the database
  Future<void> deletePerson(String name) async {
    await _databaseService.deletePerson(name);
  }
}
