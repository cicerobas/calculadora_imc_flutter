import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

const String createTable = '''
  CREATE TABLE imcs(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    peso REAL,
    altura REAL,
    imc REAL,
    status TEXT,
    cor INTEGER
  )
''';

class SQLiteDatabase {
  static Database? db;

  Future<Database> getDb() async => db ?? await startDB();

  Future startDB() async {
    final db = openDatabase(
      path.join(await getDatabasesPath(), 'database.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createTable);
      },
    );
    return db;
  }
}
