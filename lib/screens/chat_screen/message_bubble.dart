import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/provider/custom_appbar.dart';
import 'package:test_app/screens/show_media_screen.dart';
import 'package:test_app/services/date_and_time.dart';

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
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              mediaUrl == null ? Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onLongPress: (){
                        longPressed = true;
                       // isPressed = true;
                        Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
                        // Provider.of<CustomAppBar>(context,listen: false).changeAppBar();
                        Provider.of<CustomAppBar>(context, listen: false).messageOptions(context);
                      },
                      onTap: (){
                        // longPressed ? Provider.of<CustomAppBar>(context,listen: false).changeAppBar() : null;
                        Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
                      },
                      child: Stack(
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width/1.25,
                               minWidth: MediaQuery.of(context).size.width/8.0,
                            ),
                            child: Container(
                              //  elevation: 0.2,
                              // color: isMe ? Colors.grey[100] : Color(0x253366ff) ,//Color(0xffe6ecff)
                              //shadowColor: Color(0xfff4f4f7),
                              decoration: BoxDecoration(
                                color: isMe ? Color(0xff37c882) : Colors.white,
                                border: isMe ? null : Border.all(color: Color(0x90989dac), width: 0.6),
                                borderRadius: BorderRadius.only(
                                  topLeft: isMe ? Radius.circular(8.0) : Radius.circular(0.0),
                                  topRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: isMe ? Radius.circular(0.0) : Radius.circular(8.0),
                                )
                              ),
                              // borderRadius: BorderRadius.only(
                              //   topLeft: isMe ? Radius.circular(8.0) : Radius.circular(0.0),
                              //   topRight: Radius.circular(8.0),
                              //   bottomLeft: Radius.circular(8.0),
                              //   bottomRight:
                              //   isMe ? Radius.circular(0.0) : Radius.circular(8.0),
                              // ),
                              child:Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                child:  Text(
                                  text,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Poppins',
                                      color: isMe ? Colors.white : Color(0xff070707) ,//Color(0xff36ae5b)
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]) : Column(
                crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=> ShowMediaScreen(
                                mediaLink: mediaUrl,
                              )));
                        },
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderOnForeground: true,
                          shadowColor: Color(0xffDCDCE5),
                          elevation: 3.0,

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              mediaUrl,
                              fit: BoxFit.fill,
                              width: 220.0,
                              height: 250.0,
                              loadingBuilder: (context,child,loadingProgress){
                                if(loadingProgress == null) return child;
                                return CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                      : null,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
//                    BackdropFilter(
//                      child: Container(
//                        color: Colors.black12,
//                      ),
//                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//                    ),
//                    Positioned(
//                        top: 5.0,
//                        bottom: 5.0,
//                        left: 5.0,
//                        right: 5.0,
//                        child: IconButton(
//                          icon: Icon(Icons.get_app),
//                          color: Colors.grey[700],
//                          iconSize: 50.0,
//                          onPressed: (){
//                            print('download');
//                          },
//                        ),
//                    )
                    ],
                  ),
                  SizedBox(height: 3.0),
                  text !=null && text!= '' ? GestureDetector(
                    onLongPress: (){
                      longPressed = true;
                     // isPressed = true;
                      Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
                      // Provider.of<CustomAppBar>(context,listen: false).changeAppBar();
                      Provider.of<CustomAppBar>(context, listen: false).messageOptions(context);
                    },
                    onTap: (){
                      // longPressed ? Provider.of<CustomAppBar>(context,listen: false).changeAppBar() : null;
                      Provider.of<CustomAppBar>(context,listen: false).selectedMessages(id);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        child: Text(
                          text,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: isMe ?  Colors.black54 : Colors.blue
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.grey[100] : Color(0x253366ff),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ): Container(),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                DateAndTime().getDateAndTime(time),
                style: TextStyle(
                    color: Color(0xff989dac),
                    fontWeight: FontWeight.w500,
                    fontSize: 10.0),
              ),
            ],
          )
      ),
    );
  }

}