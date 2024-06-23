import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobile_app_task_final/models/person.dart';

class DatabaseService {
  static final DatabaseService _singleton  = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'Task_Database.db');
      print('Initializing database...');
      Database database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
      print('Database initialized successfully');
      return database;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future _onCreate(Database db, int version) async {
    print('Database tables created...');
    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskName TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE persons (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      memberName TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE person_tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      personName TEXT NOT NULL,
      taskTitle TEXT NOT NULL,
      count INTEGER NOT NULL,
      FOREIGN KEY (taskTitle) REFERENCES tasks (taskName),
      FOREIGN KEY (personName) REFERENCES persons (memberName)
    )
    ''');
  }

  Future<void> insertOrUpdatePersonTask(PersonTask personTask) async {
    final db = await database;
    final List<Map<String, dynamic>> existing = await db.query('person_tasks',
        where: 'personName = ? AND taskTitle = ?', whereArgs: [personTask.personName, personTask.taskTitle]);

    if (existing.isNotEmpty) {
      // If a row already exists, update the count
      await db.rawUpdate(
        'UPDATE person_tasks SET count = ? WHERE personName = ? AND taskTitle = ?',
        [personTask.count, personTask.personName, personTask.taskTitle],
      );
    } else {
      // Otherwise, insert a new row
      await db.insert('person_tasks', personTask.toMap());
    }

    print('PersonTask inserted or updated successfully: $personTask');
  }

  Future<List<PersonTask>> personTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('person_tasks');

    return List.generate(maps.length, (i) {
      return PersonTask.fromMap(maps[i]);
    });
  }

  Future<List<String>> queryTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return maps[i]['taskName'] as String;
    });
  }

  Future<void> insertTaskName(String taskName) async {
    final db = await database;
    await db.insert(
      'tasks',
      {'taskName': taskName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPersonName(String personName) async {
    final db = await database;
    await db.insert(
      'persons',
      {'memberName': personName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> queryPersons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('persons');

    return List.generate(maps.length, (i) {
      return maps[i]['memberName'] as String;
    });
  }

  Future<void> deleteTask(String name) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'taskName = ?',
      whereArgs: [name],
    );
  }

  Future<void> deletePerson(String name) async {
    final db = await database;
    await db.delete(
      'persons',
      where: 'memberName = ?',
      whereArgs: [name],
    );
  }
}
