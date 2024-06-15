import 'package:mobile_app_task_final/repositories/task_repository.dart';
import 'package:mobile_app_task_final/models/task.dart';

class TaskService {
  final TaskRepository repository;

  TaskService(this.repository);

  List<Task> getTasks() {
    return repository.fetchTasks();
  }
}
