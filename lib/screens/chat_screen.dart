import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/models/custom_appbar.dart';
import 'package:test_app/screens/media_preview_screen.dart';
import 'package:test_app/screens/show_media_screen.dart';
import 'package:test_app/services/date_and_time.dart';
import 'package:image_picker/image_picker.dart';


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
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: Provider.of<CustomAppBar>(context).appBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatBuilder(),
            Container(
              //  decoration: kMessageContainerDecoration,
              height: 64.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.blue,
                          size: 43.0,
                        ),
                        onPressed: () async{
                            await ImagePicker().getImage(source: ImageSource.gallery).then((image){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => MediaPreviewScreen(media: image,)));
                            }
                            );
                        }
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
//                                offset: Offset(0, 1),
                                blurRadius: 0,
                                color: Colors.grey,
                              )
                            ]),
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 3.0),
                      child: MaterialButton(
                          height: 45.0,
                          shape: CircleBorder(),
                          color: Colors.blueAccent,
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
                            Icons.send,
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
    );
  }

}

class ChatBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('message')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final time = message.data['timestamp'];
          final media = message.data['mediaUrl'];

          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
            time: time.toDate(),
            id: message.documentID, // added it to implement ability to delete a chat by accessing it documentId which is unique for each chat
            mediaUrl: media,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe, this.time, this.id, this.mediaUrl});
  final String text;
  final String sender;
  final bool isMe;
  final time;
  final id;
  final String mediaUrl;

  @override
  Widget build(BuildContext context) {
    bool longPressed = false;
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child:
        Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
//              Text(
//                isMe ? 'You' : sender,
//                style: TextStyle(
//                  color: Color(0xff999999),
//                ),
//              ),
              GestureDetector(
                    onLongPress: (){
                      longPressed = true;
                      isPressed = true;
                      Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
                      Provider.of<CustomAppBar>(context,listen: false).changeAppBar();
                    },
                    onTap: (){
                      longPressed ? Provider.of<CustomAppBar>(context,listen: false).changeAppBar() : null;
                      Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
                      mediaUrl != null ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> ShowMediaScreen(
                       mediaLink: mediaUrl,
                      ))) :
                          null;
                    },
                    child: Material(
                      elevation: 1.5,
                      color: isMe ? Colors.green[50] : Color(0xffe6ecff) ,
                      shadowColor: Color(0xfff4f4f7),
                      borderRadius: BorderRadius.only(
                        topLeft: isMe ? Radius.circular(8.0) : Radius.circular(0.0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight:
                        isMe ? Radius.circular(0.0) : Radius.circular(8.0),
                      ),
                      child:Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        child: mediaUrl != null ? Column(

                            children: <Widget>[
//                              isMe ? Image.file(
//                                _imageFile,
//                                fit: BoxFit.fill,
//                                width: 220.0,
//                                height: 250.0,
//                              ) :
                             Image.network(
                               mediaUrl,
                               fit: BoxFit.fill,
                               width: 220.0,
                               height: 250.0,
                               loadingBuilder: (context,child,loadingProgress){
                                 if(loadingProgress == null) return child;
                                 return CircularProgressIndicator(
                                   backgroundColor: isMe ? Colors.green : Colors.blue,
                                   value: loadingProgress.expectedTotalBytes != null
                                       ? loadingProgress.cumulativeBytesLoaded /
                                       loadingProgress.expectedTotalBytes
                                       : null,
                                 );
                               },
                             ),
                             SizedBox(height: 5.0,),
                              Text(
                                text,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: isMe ?  Colors.green[300] : Colors.blue
                                ),
                              )
                            ],
                          ) : Text(
                          text,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: isMe ?  Colors.green[300] : Colors.blue
                          ),
                        ),
                      ),
                    ),
                  ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                DateAndTime().getDateAndTime(time),
                style: TextStyle(
                    color: Color(0xff999999),
                    fontWeight: FontWeight.w700,
                    fontSize: 10.0),
              ),
            ]),
      ),
    );
  }

}

