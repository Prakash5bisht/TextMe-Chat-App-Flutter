import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/provider/custom_appbar.dart';
import 'package:test_app/screens/chat_screen/message_bubble.dart';

class ChatBuilder extends StatelessWidget {
  ChatBuilder({@required this.storageReference});
  final Firestore storageReference;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: storageReference
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

          try{
            final currentUser = Provider.of<CustomAppBar>(context, listen: false).getCurrentUser().email;
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender,
              time: time.toDate(),
              id: message.documentID, // added it to implement ability to delete a chat by accessing it documentId which is unique for each chat
              mediaUrl: media,
            );
            messageBubbles.add(messageBubble);
          }catch(e){
            print(e);
          }

        }
        return Expanded(
          child: ScrollConfiguration(
            behavior: ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
            child: Scrollbar(
              child: ListView(
                reverse: true,
                children: messageBubbles,
              ),
            ),
          ),
        );
      },
    );
  }
}