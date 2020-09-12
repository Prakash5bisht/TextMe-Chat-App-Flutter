import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

final Firestore _firestore = Firestore.instance;

class CustomAppBar extends ChangeNotifier{

  BuildContext context;

  Set<String> messages = {};

String id;
 // bool _change = false;

//  Widget appBar(){
//    return _change ? chatOptionAppBar() : defaultAppBar();
//  }
//
//   void changeAppBar(){
//    _change = !_change;
//    notifyListeners();
//   }

   void selectedMessages(String messageId){
    messages.add(messageId);
   }


 Widget defaultAppBar() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, onPressed: ()=> Navigator.pop(context),),
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
                //changeAppBar();
                Navigator.pop(context);
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
                Navigator.pop(context);
//                changeAppBar();
              },
            )
          ],
        );
      }
    );

  }


  PersistentBottomSheetController messageOptions(BuildContext context){
    var mediaQuery = MediaQuery.of(context).size;
    return showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context){
          return Padding(
            padding: const EdgeInsets.only(bottom: 64.0,left: 17.0, right: 17.0),
            child: Container(
              height: mediaQuery.height/12.0,
              width: mediaQuery.width,
              decoration: BoxDecoration(
             color: Color(0xcc262626),
            borderRadius: BorderRadius.circular(6.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.white,),
                      onPressed: (){
                        messages.clear();
                        Navigator.pop(context);
                      },
                    ),
                    Text('${messages.length}', style: TextStyle(color: Colors.greenAccent, fontSize: 18.0),),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.white,),
                      onPressed: (){
                        showDeleteAlert(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  Future <String> get _localPath async{
    final directory = await getExternalStorageDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<String> get localFile async{
    final path = await _localPath;
    final myDirectory =  Directory('$path/Media');
    print('0');

    if(await myDirectory.exists()){
      print('1');
      return myDirectory.path;
    }

    else{
      final newDirectory = await myDirectory.create(recursive: false);
      print('2');
      return newDirectory.path;
    }
  }

  Future<String> initDownloadsDirectory() async{
     Directory downloadsDirectory;
     downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
     return downloadsDirectory.path;
  }
}