import 'package:sqflite/sqflite.dart'; // Import SQFLite library for SQLite operations
import 'package:path/path.dart'; // Import path library to handle file paths
import 'package:mobile_app_task_final/models/person.dart'; // Import PersonTask model

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal(); // Singleton instance of DatabaseService
  static Database? _database; // Static database instance

  factory DatabaseService() {
    return _singleton; // Factory constructor to return the singleton instance
  }

  DatabaseService._internal(); // Private constructor for singleton pattern

  Future<Database> get database async {
    if (_database != null) return _database!; // Return existing database instance if available

    _database = await _initDatabase(); // Initialize database if not already done
    return _database!; // Return the initialized database instance
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'Task_Database.db'); // Define the database path
      print('Initializing database...');
      Database database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      ); // Open or create the database at the specified path with version 1
      print('Database initialized successfully');
      return database; // Return the initialized database instance
    } catch (e) {
      print('Error initializing database: $e'); // Print error if database initialization fails
      rethrow; // Rethrow the error to handle it elsewhere if needed
    }
  }

  Future _onCreate(Database db, int version) async {
    print('Database tables created...');
    // Create tables in the database if they do not exist
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
      return PersonTask.fromMap(maps[i]); // Convert database query results to List<PersonTask>
    });
  }

  Future<List<String>> queryTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return maps[i]['taskName'] as String; // Extract task names from database query results
    });
  }

  Future<void> insertTaskName(String taskName) async {
    final db = await database;
    await db.insert(
      'tasks',
      {'taskName': taskName}, // Insert task name into 'tasks' table
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts by replacing existing data
    );
  }

  Future<void> insertPersonName(String personName) async {
    final db = await database;
    await db.insert(
      'persons',
      {'memberName': personName}, // Insert person name into 'persons' table
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts by replacing existing data
    );
  }

  Future<List<String>> queryPersons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('persons');

    return List.generate(maps.length, (i) {
      return maps[i]['memberName'] as String; // Extract person names from database query results
    });
  }

  Future<void> deleteTask(String name) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'taskName = ?',
      whereArgs: [name], // Delete task from 'tasks' table based on task name
    );
  }

  Future<void> deletePerson(String name) async {
    final db = await database;
    await db.delete(
      'persons',
      where: 'memberName = ?',
      whereArgs: [name], // Delete person from 'persons' table based on person name
    );
  }

  Future<void> deletePersonTask(String taskTitle, String personName) async {
    final db = await database;
    await db.delete(
      'person_tasks',
      where: 'taskTitle = ? AND personName = ?',
      whereArgs: [taskTitle, personName],
    );
  }
}
