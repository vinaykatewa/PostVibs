import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:postvibs/sqllite/sqlModel.dart';

class SqliteHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE my_table (
            id INTEGER,
            title TEXT,
            description TEXT,
            category TEXT,
            path TEXT,
            location TEXT
          )
        ''');
      },
    );
  }

  Future<int> insert(SqlModel model) async {
    final db = await database;
    return await db.insert('my_table', model.toMap());
  }

  Future<List<SqlModel>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('my_table');
    return List.generate(maps.length, (i) {
      return SqlModel(
          id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          category: maps[i]['category'],
          path: maps[i]['path'],
          location: maps[i]['location']);
    });
  }
}
