import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/model/task_data_model.dart';

class DatabaseService {
  Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  final String _databaseName = "todo_db";
  final String _tableName = "task_table";
  final String _columnIdName = "id";
  final String _columnTaskName = "task";
  final String _columnStatusName = "status";
  final String _columnTimeStampName = "timeStamp";

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, _databaseName);

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            $_columnIdName INTEGER PRIMARY KEY,
            $_columnTaskName TEXT NOT NULL,
            $_columnStatusName INTEGER NOT NULL,
            $_columnTimeStampName INTEGER NOT NULL
          )
          ''');
      },
    );

    return database;
  }

  Future<List<TaskDataModel>> getToDoList() async {
    final db = await database;
    final data = await db.query(_tableName, orderBy: '$_columnTimeStampName ASC');
    List<TaskDataModel> taskList = data
        .map((e) => TaskDataModel(
            id: e[_columnIdName] as int,
            task: e[_columnTaskName] as String,
            status: e[_columnStatusName] as int,
      currentTimeStamp: e[_columnTimeStampName] as int
    ))
        .toList();

    return taskList;
  }

  void addTaskToDatabase(int number, String task, int status) async {
    final db = await database;
    await db.insert(_tableName, {
      _columnIdName: number,
      _columnTaskName: task,
      _columnStatusName: status,
      _columnTimeStampName: DateTime.now().millisecondsSinceEpoch,
    });
  }

  void changeTaskToDatabase(int id, String task) async {
    final db = await database;
    await db.update(
        _tableName,
        {
          _columnTaskName: task,
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  void changeStatusToDatabase(int id, int status) async {
    final db = await database;
    await db.update(
        _tableName,
        {
          _columnStatusName: status,
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  void deleteTaskFromDatabase(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
