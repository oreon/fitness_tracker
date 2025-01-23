import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fitness_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        food TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        activity TEXT NOT NULL,
        score INTEGER NOT NULL
      )
    ''');
  }

  Future<void> logFood(String date, String mealType, String food) async {
    final db = await database;
    await db.insert('food_logs', {
      'date': date,
      'meal_type': mealType,
      'food': food,
    });
  }

  Future<void> logScore(String date, String activity, int score) async {
    final db = await database;
    await db.insert('scores', {
      'date': date,
      'activity': activity,
      'score': score,
    });
  }

  Future<int> getTotalScore(String date) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(score) as total FROM scores WHERE date = ?',
      [date],
    );
    return result.first['total'] as int? ?? 0;
  }
}
