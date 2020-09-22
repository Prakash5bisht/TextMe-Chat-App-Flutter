import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/provider/custom_appbar.dart';
import 'package:test_app/screens/share_media_screen.dart';
import 'dart:ui';

import 'chat_builder.dart';


FirebaseUser loggedInUser;
final Firestore _firestore = Firestore.instance;
bool isPressed = false;
String uploadedFileUrl;


class ChatScreen extends StatefulWidget {

  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  final FirebaseAuth _auth = FirebaseAuth.instance;

  var textMessage = '';
  final textController = TextEditingController();



  @override
  void initState() {
    super.initState();
    getCurrentUser();
    Provider.of<CustomAppBar>(context,listen: false).context = context;
  }


  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        Provider.of<CustomAppBar>(context, listen: false).setCurrentUser(loggedInUser);
        print('user : ${loggedInUser.email}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
////          mainAxisAlignment: MainAxisAlignment.spaceBetween,
////          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 55.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ChatBuilder(storageReference: _firestore),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 23.0),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ShareMediaScreen(),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 135.0
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(35.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xffeef0f8),
                                              blurRadius: 6.0,
                                              spreadRadius: 2.0,
                                             // offset: Offset(-1, 1)
                                            )
                                          ]
                                           ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 28.0),
                                        child: ScrollConfiguration(
                                        behavior: ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                                          child: Scrollbar(
                                            child: TextField(
                                              controller: textController,
                                              style: TextStyle(fontSize: 18.0),
                                              onChanged: (value) {
                                                textMessage = value;
                                              },
                                              decoration: kMessageTextFieldDecoration,
                                              textCapitalization: TextCapitalization.sentences,
                                              maxLines: null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          bottom: 8.0,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1.5),
                            child: MaterialButton(
                              height: 48.5,
                              shape: CircleBorder(),
                              color: Color(0xff3366ff),
                              elevation: 5,
                              onPressed: () {
                                textController.clear();
                                _firestore.collection('message').add({
                                  'text': textMessage,
                                  'sender': loggedInUser.email,
                                  'timestamp': new DateTime.now().toUtc(),
                                });
                                textMessage = '';
                              },
                              child: Icon(
                                Icons.chevron_right,
                                size: 29.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: -2.0,
                left: 0.0,
                right: 0.0,
                child: Provider.of<CustomAppBar>(context).defaultAppBar()
            )
          ],
        ),
      )
    );
  }

}

// class ChatBuilder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('message')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.blueAccent,
//             ),
//           );
//         }
//         final messages = snapshot.data.documents;
//         List<MessageBubble> messageBubbles = [];
//         for (var message in messages) {
//           final messageText = message.data['text'];
//           final messageSender = message.data['sender'];
//           final time = message.data['timestamp'];
//           final media = message.data['mediaUrl'];
//
//           final currentUser = loggedInUser.email;
//           final messageBubble = MessageBubble(
//             text: messageText,
//             sender: messageSender,
//             isMe: currentUser == messageSender,
//             time: time.toDate(),
//             id: message.documentID, // added it to implement ability to delete a chat by accessing it documentId which is unique for each chat
//             mediaUrl: media,
//           );
//           messageBubbles.add(messageBubble);
//         }
//         return Expanded(
//           child: ScrollConfiguration(
//             behavior: ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
//             child: Scrollbar(
//               child: ListView(
//                 reverse: true,
//                 children: messageBubbles,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
// class MessageBubble extends StatelessWidget {
//   MessageBubble({this.text, this.sender, this.isMe, this.time, this.id, this.mediaUrl});
//   final String text;
//   final String sender;
//   final bool isMe;
//   final time;
//   final id;
//   final String mediaUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     bool longPressed = false;
//     return InkWell(
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: <Widget>[
//             mediaUrl == null ? Column(
//                 crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: <Widget>[
//                   GestureDetector(
//                     onLongPress: (){
//                       longPressed = true;
//                       isPressed = true;
//                       Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
//                       // Provider.of<CustomAppBar>(context,listen: false).changeAppBar();
//                       Provider.of<CustomAppBar>(context, listen: false).messageOptions(context);
//                     },
//                     onTap: (){
//                      // longPressed ? Provider.of<CustomAppBar>(context,listen: false).changeAppBar() : null;
//                       Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
//                     },
//                     child: Stack(
//                       children: <Widget>[
//                         ConstrainedBox(
//                           constraints: BoxConstraints(
//                             maxWidth: MediaQuery.of(context).size.width/1.25,
//                            // minWidth: MediaQuery.of(context).size.width/8.0,
//                           ),
//                           child: Material(
//                             //  elevation: 0.2,
//                             color: isMe ? Colors.grey[100] : Color(0x253366ff) ,//Color(0xffe6ecff)
//                             shadowColor: Color(0xfff4f4f7),
//                             borderRadius: BorderRadius.only(
//                               topLeft: isMe ? Radius.circular(8.0) : Radius.circular(0.0),
//                               topRight: Radius.circular(8.0),
//                               bottomLeft: Radius.circular(8.0),
//                               bottomRight:
//                               isMe ? Radius.circular(0.0) : Radius.circular(8.0),
//                             ),
//                             child:Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//                               child:  Text(
//                                 text,
//                                 style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: isMe ?  Colors.black54 : Colors.blue,
//                                     fontWeight: FontWeight.w500
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ]) : Column(
//               crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
//               children: <Widget>[
//                 Stack(
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: (){
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context)=> ShowMediaScreen(
//                               mediaLink: mediaUrl,
//                             )));
//                       },
//                       child: Material(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         borderOnForeground: true,
//                         shadowColor: Color(0xffDCDCE5),
//                         elevation: 3.0,
//
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10.0),
//                           child: Image.network(
//                             mediaUrl,
//                             fit: BoxFit.fill,
//                             width: 220.0,
//                             height: 250.0,
//                             loadingBuilder: (context,child,loadingProgress){
//                               if(loadingProgress == null) return child;
//                               return CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                     loadingProgress.expectedTotalBytes
//                                     : null,
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
// //                    BackdropFilter(
// //                      child: Container(
// //                        color: Colors.black12,
// //                      ),
// //                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
// //                    ),
// //                    Positioned(
// //                        top: 5.0,
// //                        bottom: 5.0,
// //                        left: 5.0,
// //                        right: 5.0,
// //                        child: IconButton(
// //                          icon: Icon(Icons.get_app),
// //                          color: Colors.grey[700],
// //                          iconSize: 50.0,
// //                          onPressed: (){
// //                            print('download');
// //                          },
// //                        ),
// //                    )
//                   ],
//                 ),
//                 SizedBox(height: 3.0),
//                 text !=null && text!= '' ? GestureDetector(
//                   onLongPress: (){
//                     longPressed = true;
//                     isPressed = true;
//                     Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
//                     // Provider.of<CustomAppBar>(context,listen: false).changeAppBar();
//                     Provider.of<CustomAppBar>(context, listen: false).messageOptions(context);
//                   },
//                   onTap: (){
//                    // longPressed ? Provider.of<CustomAppBar>(context,listen: false).changeAppBar() : null;
//                     Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
//                   },
//                   child: Container(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//                       child: Text(
//                         text,
//                         style: TextStyle(
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.w500,
//                             color: isMe ?  Colors.black54 : Colors.blue
//                         ),
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.grey[100] : Color(0x253366ff),
//                       borderRadius: BorderRadius.circular(6.0),
//                     ),
//                   ),
//                 ): Container(),
//               ],
//             ),
//             SizedBox(
//               height: 4.0,
//             ),
//             Text(
//               DateAndTime().getDateAndTime(time),
//               style: TextStyle(
//                   color: Color(0xff999999),
//                   fontWeight: FontWeight.w700,
//                   fontSize: 10.0),
//             ),
//           ],
//         )
//       ),
//     );
//   }
//
// }
//
