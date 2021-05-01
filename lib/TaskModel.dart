import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "todo";
final String Column_id = "id";
final String Column_bunga = "bunga";

class TaskModel {
  final String bunga;
  int id;

  TaskModel({this.bunga, this.id});
  Map<String, dynamic> toMap() {
    return {Column_bunga: this.bunga};
  }
}

class TodoHelper {
  Database db;

  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "dela.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTERGER PRIMARY KEY AUTO INCREMENT , $Column_bunga TEXT)");
    }, version: 1);
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      print(_);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    List.generate(tasks.length, (i) {
      return TaskModel(bunga: tasks[i][Column_bunga], id: tasks[i][Column_id]);
    });
  }
}
