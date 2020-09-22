import 'dart:ui';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:test_app/components/custom_alert_dialog.dart';
import 'package:test_app/custom_icons_set_icons.dart';
import 'package:test_app/screens/chat_screen_components.dart';

final Firestore _firestore = Firestore.instance;

class CustomAppBar extends ChangeNotifier{

  BuildContext context;

  FirebaseUser _user;


  Set<String> messages = {};

  String id;

  FirebaseUser getCurrentUser(){
    return _user;
  }

  void setCurrentUser(FirebaseUser firebaseUser){
    _user = firebaseUser;
  }
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

   void copyText(String text){
    Clipboard.setData(new ClipboardData(text: text));
   }

 Widget defaultAppBar() {
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

//   void showDeleteAlert(context) {
//
//     String text = messages.length > 1 ? 'messages' : 'message';
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context){
//         return AlertDialog(
//           title: Text('Delete ${messages.length} $text'),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
//           content: Row(
//             children: <Widget>[
//               Icon(Icons.check_box,color: Colors.blue,),
//               SizedBox(width: 5.0,),
//               Text('delete chats or media?'),
//             ],
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('CANCEL'),
//               onPressed: (){
//                 Navigator.pop(context);
//                 messages.clear();
//                 //changeAppBar();
//                 Navigator.pop(context);
//               },
//             ),
//             FlatButton(
//               child: Text('DELETE'),
//               onPressed: (){
//                 Navigator.pop(context);
//                 for(int i = 0; i<messages.length; i++){
//                   _firestore.collection('message').document(messages.elementAt(i)).delete();
//                 }
//                 messages.clear();
//                 Navigator.pop(context);
// //                changeAppBar();
//               },
//             )
//           ],
//         );
//       }
//     );
//
//   }


  PersistentBottomSheetController messageOptions({BuildContext context, String message}){
    var mediaQuery = MediaQuery.of(context).size;
    return showBottomSheet(
        context: context,
        elevation: 0.0,
        backgroundColor: Colors.white,//Colors.transparent,
        builder: (context){
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0,left: 10.0, right: 10.0),
            child: Container(
              height: mediaQuery.height/11.0,
              width: mediaQuery.width,
              decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(14.0),
             border: Border.all(color: Color(0x90989dac), width: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x10263238),
                     blurRadius: 18.0,
                     spreadRadius: 1.0,
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.clear, color: Color(0xff262626), size: 20.0,),
                      onPressed: (){
                        messages.clear();
                        Navigator.pop(context);
                      },
                    ),
                    MaterialButton(
                      elevation: 0.0,
                      color: Color(0xffffebe6),
                      shape: CircleBorder(),
                      height: 42.0,
                      child: Icon(CustomIconsSet.share_social_interface_button, color: Colors.deepOrange, size: 20.0,),
                      onPressed: (){

                      },
                    ),
                    MaterialButton(
                      elevation: 0.0,
                      color: Color(0xffe6e6ff),
                      shape: CircleBorder(),
                      height: 42.0,
                      child: Icon(CustomIconsSet.copy_two_paper_sheets_interface_symbol, color: Color(0xff0a05ff), size: 22.0,),
                      onPressed: (){
                       copyText(message);
                       print('copied');
                       Navigator.pop(context);
                      },
                    ),
                    MaterialButton(
                      elevation: 0.0,
                       color: Color(0xfff0f1f4),
                       shape: CircleBorder(),
                       height: 42.0,
                       child: Icon(CustomIconsSet.recycling_bin, color: Color(0xff57607a), size: 22.0,),
                      onPressed: (){
                        String text = messages.length > 1 ? 'messages' : 'message';

                        showAlert(context: context,alert: 'Complete Action?', description: 'Delete ${messages.length} $text',
                        defaultButtonName: 'Cancel',
                        optionalButtonName: 'Delete',
                          optionalButtonColor: Color(0xffe65e5e),
                          onPressOptionalButton: (){
                              Navigator.pop(context);
                              for(int i = 0; i<messages.length; i++){
                                _firestore.collection('message').document(messages.elementAt(i)).delete();
                              }
                              messages.clear();
                              Navigator.pop(context);
                          }
                        );
                      },
                    ),
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