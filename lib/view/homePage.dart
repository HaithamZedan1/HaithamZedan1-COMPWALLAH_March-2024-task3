import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timetable/controller/taskController.dart';
import 'package:timetable/model/task.dart';
import 'package:timetable/theme.dart';
import 'package:timetable/view/addTaskBar.dart';
import 'package:timetable/view/button.dart';
import 'package:timetable/view/taskTile.dart';

class HomePage extends StatefulWidget {
  final int? userId;
  HomePage({Key? key,required this.userId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate=DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    _taskController.getTasks(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Your time table"),
        backgroundColor: white,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: const Icon(Icons.logout,size: 20,color: Colors.black),
        ),
      ),
      body: Container(
        color: white,
        child: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(height: 18),
            _showTasks()
          ],
        ),
      ),
    );
  }

  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_,index){
            Task task = _taskController.taskList[index];
            if(task.repeat == "Daily"){
            return AnimationConfiguration.staggeredList(position:index,child: SlideAnimation(
              child: FadeInAnimation(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        _showBottomSheet(context,task);
                      },
                      child: TaskTile(task),
                    )
                  ],
                ),
              ),
            )
            );} if(task.date == DateFormat.yMd().format(_selectedDate)){
              return AnimationConfiguration.staggeredList(position:index,child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          _showBottomSheet(context,task);
                        },
                        child: TaskTile(task),
                      )
                    ],
                  ),
                ),
              )
              );
            }
            else{
                return Container();
            }
          },
        );
      }),
    );
  }

  _showBottomSheet(BuildContext context,Task task){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.32
        ,
        color: white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300]
              ),
            ),
            SizedBox(height: 20,),
            task.isCompleted==1?Container():
            _bottomSheetButton(label: "Task Completed", onTap: (){
              _taskController.markTaskCompleted(task.taskId!);
              _taskController.getTasks(widget.userId);
              Get.back();
            }, clr: primaryClr,context: context),Spacer(),
            _bottomSheetButton(label: "Delete Task", onTap: (){
              _taskController.delete(task);
              _taskController.getTasks(widget.userId);
              Get.back();
            }, clr: Colors.red[300]!,context: context),SizedBox(height: 20,),
            _bottomSheetButton(label: "Close", onTap: (){
              Get.back();
            }, clr: Colors.red,isClose: true,context: context),SizedBox(height: 10,)
          ],
        ),
      )
    );
  }


  _bottomSheetButton({required String label,required Function()? onTap,
    required Color clr,bool isClose=false,required BuildContext context}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose?Colors.grey[300]!:clr,
          ),
            color: isClose?Colors.white:clr,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Text(
            label,
            style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top:20,left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dayTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        dateTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        monthTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        onDateChange: (date){
          setState(() {
            _selectedDate=date;
          });
        },
      ),
    );
  }

  _addTaskBar(){
    return  Container(
      margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today",
                  style: headingStyle,
                ),

              ],
            ),
          ),
          MyButton(label: "+ Add Task", onTap: ()=>Get.to(AddTaskPage(userId: widget.userId)))
        ],
      ),
    );
  }
}