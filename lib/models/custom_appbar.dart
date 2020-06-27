import 'package:flutter/material.dart';

class CustomAppBar extends ChangeNotifier{

  bool change = false;

  Widget appBar(){
    return change ? AppBar(backgroundColor: Colors.blue,

    actions: <Widget>[
      Icon(Icons.forward),
      SizedBox(width: 50.0,),
      Icon(Icons.content_copy),
      SizedBox(width: 50.0,),
      Icon(Icons.delete),
      SizedBox(width: 10.0,)
    ],
    )
        : AppBar(backgroundColor: Colors.white,
      iconTheme: IconThemeData(
          color: Colors.black54
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            color: Colors.black,
            iconSize: 30.0,
            onPressed: () {
//                _auth.signOut();
//                Navigator.pop(context);
            }),
      ],);
  }

   void changeAppBar(){
    change = !change;
    notifyListeners();
   }
}