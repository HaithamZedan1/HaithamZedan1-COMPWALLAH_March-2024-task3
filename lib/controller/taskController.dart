import 'package:get/get.dart';
import 'package:timetable/database/sqflite.dart';
import 'package:timetable/model/task.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
    super.onReady();
  }
 SqlDb myDb = SqlDb();
  var taskList = <Task>[].obs;

  Future <int> addTask({Task? task}) async {
    return await myDb.insertTask("tasks", task);
  }

  void getTasks(int? userId) async {
    if (userId != null) {
      List<Map<String,dynamic>> tasks = await myDb.readTasks(userId);
      taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    }
  }
  void delete(Task task){
     SqlDb.delete(task);

  }

  void markTaskCompleted(int id) async{
    await SqlDb.update(id);
  }

}

