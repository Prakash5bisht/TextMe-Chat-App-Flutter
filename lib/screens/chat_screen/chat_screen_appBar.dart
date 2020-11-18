import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBar({BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: AppBar(
      leading: IconButton(icon: Icon(Icons.chevron_left, size: 30.0,), color: Colors.white, onPressed: ()=> Navigator.pop(context),),
      backgroundColor: Color(0xff263238),
      //elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      ),
      iconTheme: IconThemeData(
          color: Colors.white
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            iconSize: 25.0,
            onPressed: () {

            }),
      ],),
  );
}