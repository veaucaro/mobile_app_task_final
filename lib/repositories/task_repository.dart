import 'package:mobile_app_task_final/models/task.dart';

class TaskRepository {
  List<Task> fetchTasks() {
    return [
      Task(title: 'Task 1', isCompleted: true),
      Task(title: 'Task 2', isCompleted: false),
    ];
  }
}
