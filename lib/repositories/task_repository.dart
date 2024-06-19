import 'package:mobile_app_task_final/models/person.dart';
import 'package:mobile_app_task_final/services/database_service.dart';

class TaskRepository {
  final DatabaseService _databaseService;

  TaskRepository(this._databaseService);

  Future<List<PersonTask>> fetchTasks() async {
    return await _databaseService.personTasks();
  }

  Future<List<String>> FindAllTask() async {
    return await _databaseService.queryTasks();
  }

  Future<List<String>> FindAllPerson() async {
    return await _databaseService.queryPersons();
  }

  Future<void> addTask(PersonTask personTask) async {
    await _databaseService.insertPersonTask(personTask);
  }

  Future<void> addnewTask(String taskName) async {
    await _databaseService.insertTaskName(taskName);
  }

  Future<void> addnewPerson(String personName) async {
    await _databaseService.insertPersonName(personName);
  }

  Future<void> deleteTask(String name) async {
    await _databaseService.deleteTask(name);
  }

  Future<void> deletePerson(String name) async {
    await _databaseService.deletePerson(name);
  }

}
