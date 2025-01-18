import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoo_app/models/tasks_model.dart';

/// Singleton class for interacting with the Todoo app's local database.
///
/// `DatabaseHelper` provides a central point for managing task data in a local SQLite database.
/// It utilizes a singleton pattern for efficient access and offers methods for CRUD operations on tasks.
///
/// Key functionalities:
///   - Singleton: Ensures only one instance exists using private constructor and static getter.
///   - `_initDB`: Asynchronously initializes or opens the database file.
///   - `_createDB`: Defines the schema for the "tasks" table with columns for each task property.
///   - `get database`: Getter method to access the initialized database instance.
///   - CRUD Operations:
///     - `insertTask`: Inserts a new `TodooTask` object into the database.
///     - `getAllTasks`: Retrieves all tasks as a list of `TodooTask` objects.
///     - `updateTask`: Updates an existing task in the database.
///     - `deleteTask`: Deletes a specific task identified by its ID.
class DatabaseHelper {
  static final DatabaseHelper dbInstance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        deadlineDate TEXT NOT NULL,
        deadlineTime TEXT,
        priority TEXT,
        category TEXT,
        location TEXT,
        isReminderActive INTEGER,
        isCompleted INTEGER
      )
    ''');
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('todoo_tasks_database.db');
    return _database!;
  }

  Future<TodooTask> insertTask(TodooTask task) async {
    final db = await database;
    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return task;
  }

  Future<List<TodooTask>> getAllTasks() async {
    final db = await database;
    final taskMaps = await db.query('tasks');
    return taskMaps.map((map) {
      return TodooTask.fromMap(map);
    }).toList();
  }

  Future<int> updateTask(TodooTask task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String taskId) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
