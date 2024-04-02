import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:timetable/model/task.dart';
import 'package:timetable/model/users.dart';

class SqlDb {

  static Database? _db ;

  Future<Database?> get db async {
    if (_db == null){
      _db  = await intialDb() ;
      return _db ;
    }else {
      return _db ;
    }
  }


  intialDb() async {
    String databasepath = await getDatabasesPath() ;
    String path = join(databasepath , 'timetable.db') ;
    Database mydb = await openDatabase(path , onCreate: _onCreate , version: 1  , onUpgrade:_onUpgrade ) ;
    return mydb ;
  }

  void _onUpgrade(Database db, int oldversion, int newversion) async {
    print("onUpgrade =====================================");
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "users" (
        "userId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        "userName" TEXT NOT NULL,
        "userPassword" TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE "tasks" (
        "taskId" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title STRING NOT NULL,
        note TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        date STRING NOT NULL,
        startTime STRING NOT NULL,
        endTime STRING NOT NULL,
        color INTEGER NOT NULL,
        repeat STRING NOT NULL
      )
    ''');

    print("onCreate =====================================");
  }

  
    Future <int> insertTask(String table,Task? task) async{
    Database? mydb = await db;
    int response = await mydb?.insert(table, task!.toJson())??1;
    return response;
  }
  
  Future <bool> login(Users user) async{
    Database? mydb = await db;
    var result = await mydb!.rawQuery("SELECT * FROM users WHERE userName = '${user.userName}' AND  userPassword = '${user.userPassword}'");
    if(result.isNotEmpty){
      return true;}
    else{
      return false;}
  }

   Future<int> getUserId(Users user) async {
    Database? mydb = await db;

    List<Map<String, dynamic>> result = await mydb!.rawQuery("SELECT userId FROM users WHERE userName = '${user.userName}' AND  userPassword = '${user.userPassword}'");

    if (result.isNotEmpty) {
      int userId = result.first['userId'] as int;
      return userId;
    } else {
      return -1;
    }
  }


  Future <int> signup(Users user) async{
    Database? mydb = await db;
    return mydb!.insert('users', user.toMap());
  }


    Future <List<Map<String, dynamic>>> readTasks(int userId) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query("tasks", where: "userId = ?", whereArgs: [userId]);
    return response;
  }

  static delete(Task task) async{
  return await _db!.delete("tasks",where: 'taskId = ?',whereArgs: [task.taskId]);
  }

  static update(int id) async{
   return await _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE taskId = ?
    ''',[1,id]);
  }
}
