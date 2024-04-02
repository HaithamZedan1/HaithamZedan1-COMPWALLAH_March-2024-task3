import 'package:flutter/material.dart';

const Color bluishClr = Colors.deepPurple;
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;



TextStyle get subHeadingStyle{
  return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.grey
  );
}

TextStyle get headingStyle{
  return TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
  );
}

TextStyle get titleStyle{
  return TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        color: Colors.black
  );
}

TextStyle get subTitleStyle{
  return TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[700]
  );
}


