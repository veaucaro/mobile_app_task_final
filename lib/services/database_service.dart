// services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobile_app_task_final/models/person.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE person_tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      personName TEXT NOT NULL,
      taskTitle TEXT NOT NULL,
      count INTEGER NOT NULL
    )
    ''');
  }

  Future<void> insertPersonTask(PersonTask personTask) async {
    final db = await database;
    await db.insert(
      'person_tasks',
      personTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PersonTask>> personTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('person_tasks');

    return List.generate(maps.length, (i) {
      return PersonTask.fromMap(maps[i]);
    });
  }
}
