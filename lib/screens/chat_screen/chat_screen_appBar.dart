import 'package:flutter/material.dart';

Widget appBar({BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: AppBar(
      leading: IconButton(icon: Icon(Icons.chevron_left, size: 30.0,), color: Colors.white, onPressed: ()=> Navigator.pop(context),),
      backgroundColor: Color(0xff263238),
//      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
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