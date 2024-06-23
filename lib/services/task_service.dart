import 'package:mobile_app_task_final/repositories/task_repository.dart'; // Import the TaskRepository class
import 'package:mobile_app_task_final/models/person.dart'; // Import the PersonTask model

class TaskService {
  final TaskRepository repository; // Declare a final instance of TaskRepository

  TaskService(this.repository); // Constructor to initialize TaskService with a TaskRepository instance

  // Asynchronous method to fetch tasks from the repository
  Future<List<PersonTask>> getTasks() async {
    return repository.fetchTasks(); // Call fetchTasks method from TaskRepository and return the result
  }

  // Asynchronous method to update a person's task in the repository
  Future<void> update(PersonTask personTask) async {
    return repository.update(personTask); // Call update method from TaskRepository with the provided PersonTask
  }
}
