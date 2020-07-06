import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 23.0),
  hintText: 'Type your message...',
  border: InputBorder.none,
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

const kAppBarTextStyle = TextStyle(color: Color(0xffe6e6e6), fontSize: 20.0);
const kAppBarTextFieldHintStyle = TextStyle(
  color: Color(0xff8c8c8c),
  fontSize: 18.0,
);

const kAppBarTextFieldStyle = TextStyle(
  color: Color(0xffffffff),
  fontSize: 18.0,
);