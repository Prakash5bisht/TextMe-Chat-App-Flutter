import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _firestore = Firestore.instance;

class CustomAppBar extends ChangeNotifier{

  BuildContext context;

  Set<String> messages = {};

String id;
  bool _change = false;

  Widget appBar(){
    return _change ? chatOptionAppBar() : defaultAppBar();
  }

   void changeAppBar(){
    _change = !_change;
    notifyListeners();
   }

 Widget chatOptionAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.forward),
//        ),
//        SizedBox(width: 50.0,),
//        IconButton(
//          icon: Icon(Icons.content_copy),
//        ),
        SizedBox(width: 50.0,),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: (){
           showDeleteAlert(context);
          },
        ),
        SizedBox(width: 10.0,)
      ],
    );
  }

 Widget defaultAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
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

  void showDeleteAlert(context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Delete ${messages.length} messages?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          content: Row(
            children: <Widget>[
              Icon(Icons.check_box,color: Colors.blue,),
              SizedBox(width: 5.0,),
              Text('delete chats or media?'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: (){
                Navigator.pop(context);
                messages.clear();
                changeAppBar();
              },
            ),
            FlatButton(
              child: Text('DELETE'),
              onPressed: (){
                Navigator.pop(context);
                print(messages);
                for(int i = 0; i<messages.length; i++){
                  _firestore.collection('message').document(messages.elementAt(i)).delete();
                }
                messages.clear();
                changeAppBar();
              },
            )
          ],
        );
      }
    );

  }
}