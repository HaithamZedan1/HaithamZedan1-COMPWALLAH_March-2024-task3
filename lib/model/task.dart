class Task{
  int? taskId;
  int? userId;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? reminder;
  String? repeat;

  Task({
      this.taskId,
      this.userId,
      this.title,
      this.note,
      this.isCompleted,
      this.date,
      this.startTime,
      this.endTime,
      this.color,
      this.reminder,
      this.repeat});
  Task.fromJson(Map<String,dynamic> json){
    taskId=json["taskId"];
    userId = json["userId"];
    title = json["title"];
    note=json["note"];
    isCompleted = json["isCompleted"];
    date=json["date"];
    startTime=json["startTime"];
    endTime =json["endTime"];
    color=json["color"];
    reminder=json["reminder"];
    repeat=json["repeat"];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["taskId"]=this.taskId;
    data["userId"]=this.userId;
    data["title"]=this.title;
    data["note"]=this.note;
    data["isCompleted"]=this.isCompleted;
    data["date"]=this.date;
    data["startTime"]=this.startTime;
    data["endTime"]=this.endTime;
    data["color"]=this.color;
    data["reminder"]=this.reminder;
    data["repeat"]=this.repeat;
    return data;
  }

}