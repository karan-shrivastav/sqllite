import 'package:sqflite/sqflite.dart';
import 'package:sqllite/models/sql_data_model.dart';
import 'local_database_service.dart';

class DatabaseFunctions {
  final tableName = 'todos';

  Future<void> createTable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price TEXT 
    );
  """);
  }

  Future<int> create({required String name, required String price}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (name, price) VALUES (?, ?)''',
      [name, price],
    );
  }

  Future<List<SqlDataModel>> fetchAll() async {
    final database = await DatabaseService().database;
    final todos = await database.rawQuery(
        '''SELECT * FROM $tableName ORDER BY COALESCE(price, '')''');
    return todos.map((todo) => SqlDataModel.fromSqfliteDatabase(todo)).toList();
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ? ''', [id]);
  }
}
