import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/services/date_and_time.dart';

FirebaseUser loggedInUser;
final Firestore _firestore = Firestore.instance;


class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String textMessage = '';
  final textController = TextEditingController();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
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
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        // title: Text('⚡️Chat'),
        backgroundColor: Colors.teal,
      ),
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
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 5,
                                color: Colors.grey,
                              )
                            ]
                        ),
                        child: TextField(
                          controller: textController,
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
                      padding: EdgeInsets.only(right: 10.0),
                      child: MaterialButton(
                          height: 47.0,
                          shape: CircleBorder(),
                          color: Colors.teal,
                          elevation: 5,
                          onPressed: () {
                            textController.clear();
                            _firestore.collection('message').add({
                              'text': textMessage,
                              'sender': loggedInUser.email,
                              'timestamp': new DateTime.now().toUtc(),
                            });
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )
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
      stream: _firestore.collection('message').orderBy('timestamp',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final time  = message.data['timestamp'];

          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
            time: time.toDate(),
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
  MessageBubble({this.text, this.sender, this.isMe,this.time});
  final String text;
  final String sender;
  final bool isMe;
  final time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child:
      Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start
          , children: <Widget>[
            Text(
              isMe ? 'You' : sender,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            Material(
              elevation: 4.0,
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(20.0) : Radius.circular(0.0),
                topRight: Radius.circular(18.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: isMe ? Radius.circular(0.0) : Radius.circular(18.0),
              ),
              color: isMe ? Colors.teal[400] : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isMe ? Colors.white : Color(0xff4d4d4d),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.0,),
            Text(
              DateAndTime().getDateAndTime(time),
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.0
              ),
            ),
          ]),
    );
  }
}
// 03:61:EE:AC:D5:A6:28:7F:D0:EA:8C:B2:23:65:59:0A:4A:26:D1:A9