import 'package:mobile_app_task_final/models/person.dart';
import 'package:mobile_app_task_final/services/database_service.dart';

class TaskRepository {
  final DatabaseService _databaseService;

  TaskRepository(this._databaseService);

  Future<List<PersonTask>> fetchTasks() async {
    return await _databaseService.personTasks();
  }

  Future<void> addTask(PersonTask personTask) async {
    await _databaseService.insertPersonTask(personTask);
  }
}
