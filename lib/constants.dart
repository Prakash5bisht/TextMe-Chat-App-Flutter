import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 25.0, right: 14.0),
  hintText: 'Type your message...',
  border: InputBorder.none,
  hintStyle: TextStyle(color: Colors.grey),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);


const kInputFieldDecoration = InputDecoration(
  hintText: 'input',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),

  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kAppBarTextStyle = TextStyle(color: Color(0xff989dac), fontSize: 15.0, fontWeight: FontWeight.w600, fontFamily: 'Poppins');
const kAppBarTextFieldHintStyle = TextStyle(
  color: Color(0xff989dac),
  fontSize: 15.0,
  fontFamily: 'Poppins'
);

const kAppBarTextFieldStyle = TextStyle(
  color: Color(0xff4d4d4d),
  fontSize: 18.0,
);

const kShareMediaScreenTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 12.0,
  fontFamily: 'Poppins',
  color: Color(0x900d0e13),//Color(0xff989dac),
);