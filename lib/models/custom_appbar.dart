import 'package:flutter/cupertino.dart';
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

   void selectedMessages(String messageId){
    messages.add(messageId);
   }

 Widget chatOptionAppBar() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AppBar(
        backgroundColor: Color(0xff263238),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
       ),
       // elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.clear,),
          onPressed: (){
            changeAppBar();
            messages.clear();
          },
        ),
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
      ),
    );
  }

 Widget defaultAppBar() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AppBar(
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
//                _auth.signOut();
//                Navigator.pop(context);
              }),
        ],),
    );
 }

  void showDeleteAlert(context) {

    String text = messages.length > 1 ? 'messages' : 'message';
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Delete ${messages.length} $text'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
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