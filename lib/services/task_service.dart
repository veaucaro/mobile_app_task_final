// services/task_service.dart
import 'package:mobile_app_task_final/repositories/task_repository.dart';
import 'package:mobile_app_task_final/models/person.dart';

class TaskService {
  final TaskRepository repository;

  TaskService(this.repository);

  Future<List<PersonTask>> getTasks() async {
    return repository.fetchTasks();
  }

  Future<void> addTask(PersonTask personTask) async {
    return repository.addTask(personTask);
  }
}
