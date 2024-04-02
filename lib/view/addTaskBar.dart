import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timetable/controller/taskController.dart';
import 'package:timetable/model/task.dart';
import 'package:timetable/theme.dart';
import 'package:timetable/view/button.dart';
import 'package:timetable/view/homePage.dart';
import 'package:timetable/view/inputField.dart';

class AddTaskPage extends StatefulWidget {
  final int? userId;
  AddTaskPage({Key? key,required this.userId}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController= Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController= TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime= DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int _selectedRemind= 5;
  List<int> remindList=[
    5,
    10,
    15,
    20
  ];
  String _selectedRepeat= "None";
  List<String> repeatList=[
    "None",
    "Daily",
  ];
  int _selectedColor=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          title: Text("Your time table"),
          backgroundColor: white,
          leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios,size: 20,color: Colors.black),
          ),
        ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(title: 'Title',hint : "Enter your title",controller: _titleController, ),
              MyInputField(title: 'Note',hint : "Enter your Note" ,controller: _noteController),
              MyInputField(title: 'Date',hint : DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                 onPressed: (){
                   _getDateFromUser();
                 },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(title: "Start Date",hint: _startTime,
                      widget: IconButton(
                      icon: Icon(Icons.access_time_rounded,color: Colors.grey)
                      ,onPressed: (){
                        _getTimeFromUser(isStartTime: true);
                      },
                      ),
                      ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(title: "End Date",hint: _endTime,
                      widget: IconButton(
                        icon: Icon(Icons.access_time_rounded,color: Colors.grey)
                        ,onPressed: (){
                        _getTimeFromUser(isStartTime: false);
                      },
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
              widget:DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey),
                iconSize:  32,
                elevation: 4,
                style: subTitleStyle,
                underline: Container(height: 0,),
                onChanged: (String? newValue){
                  setState(() {
                    _selectedRemind = int.parse(newValue!);
                  });
                },
                items: remindList.map<DropdownMenuItem<String>>((int value){
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
              },
              ).toList())
                ,),
              MyInputField(title: "Repeat", hint: "$_selectedRepeat",
                widget:DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey),
                    iconSize:  32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0,),
                    onChanged: (String? newValue){
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    items: repeatList.map<DropdownMenuItem<String>>((String? value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!, style: TextStyle(color: Colors.grey),),
                      );
                    },
                    ).toList())
                ,),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: ()=>_validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() async{
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();
      Get.back();
      await Get.to(HomePage(userId: widget.userId));
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required", "All the fields are required",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: white,
      colorText: pinkClr,
      icon: Icon(Icons.warning_amber_rounded,color: Colors.red),);
    }
  }

  _addTaskToDb() async{
    int value = await _taskController.addTask(task: Task(
      userId: widget.userId,
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      reminder: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0
    ));
  }


  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
          style: titleStyle,),
        SizedBox(height: 8,),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (int index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedColor = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index == 0?primaryClr:index==1?pinkClr:yellowClr,
                      child: _selectedColor == index?Icon(Icons.done,
                        color: white,
                        size: 16,):Container(),
                    ),
                  ),
                );
              }
          ),
        )
      ],
    );
  }

  _getDateFromUser() async{
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2100));
    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
}

  _getTimeFromUser({required bool isStartTime}) async{
  var pickedTime = await _showTimePicker();
  String _formatedTime = pickedTime.format(context);
  if(isStartTime == true)
   {
     setState(() {
       _startTime = _formatedTime;
     });
   }else if (isStartTime == false){
    setState(() {
      _endTime = _formatedTime;
    });
  }

  }

  _showTimePicker(){
    return showTimePicker(initialEntryMode: TimePickerEntryMode.input,context: context, initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }
}
