import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_sqlite_example/app/models/task_model.dart';
import '../utils/settings.dart';

class TodoRepository {
  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) {
        return db.execute(CREATE_TASKS_TABLE_SCRIPT);
      },
      version: 1,
    );
  }

  Future create(TaskModel model) async {
    try {
      final Database db = await _getDatabase();

      return await db.insert(
        TABLE_NAME,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future<List<TaskModel>> getTasks() async {
    try {
      final Database db = await _getDatabase();
      String sql = "SELECT * FROM $TABLE_NAME ORDER BY date DESC";
      final List<Map<String, dynamic>> maps = await db.rawQuery(sql);

      return List.generate(
        maps.length,
        (i) {
          return TaskModel(
            id: maps[i]['id'],
            name: maps[i]['name'],
            date: maps[i]['date'],
          );
        },
      );
    } catch (ex) {
      print(ex);
      return <TaskModel>[];
    }
  }

  Future update(TaskModel model) async {
    try {
      final Database db = await _getDatabase();

      await db.update(
        TABLE_NAME,
        model.toJson(),
        where: "id = ?",
        whereArgs: [model.id],
      );
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future delete(int id) async {
    try {
      final Database db = await _getDatabase();
      await db.delete(
        TABLE_NAME,
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (ex) {
      print(ex);
      return;
    }
  }
}
