import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetable/view/addTaskBar.dart';
import 'package:timetable/view/homePage.dart';
import 'package:timetable/view/login.dart';
import 'package:timetable/view/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Time Table App',
      home: LoginScreen(),
    );
  }
}

