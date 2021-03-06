import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:test_app/constants.dart';
//import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'package:test_app/provider/provider_class.dart';


var message = '';

String uploadedFileUrl;

FirebaseUser loggedInUser;

class MediaPreviewScreen extends StatefulWidget {
  static const String id = 'media_preview_screen';

  MediaPreviewScreen({@required this.media});

  final PickedFile media;

  @override
  _MediaPreviewScreenState createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

   final textFieldController = TextEditingController();

//   VideoPlayerController _controller;
//   Future<void> _initializeVideoPlayer;


   @override
  void initState() {
    super.initState();
    getCurrentUser();
//    _controller = VideoPlayerController.file(File(widget.media.path));
//    _initializeVideoPlayer = _controller.initialize();
  }
  void getCurrentUser() async{
     try{
       final user = await _auth.currentUser();
       if(user != null){
         loggedInUser = user;
       }
     }catch(e){
       print(e);
     }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 5.0, right: 5.0),
              child: Container(
                child: Center(
                    child: PhotoView(
                      imageProvider: FileImage(File(widget.media.path)),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: 2.0,
                    )
//                child: _controller.value.initialized ?
//                  AspectRatio(
//                    aspectRatio: _controller.value.aspectRatio,
//                      child: VideoPlayer(_controller),
//                  ) : Container(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
               // height: 64.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(35.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                            )
                          ]
                        ),
                        child: TextField(
                          controller: textFieldController,
                          style: TextStyle(fontSize: 18.0 , color: Colors.white),
                          onChanged: (value){
                            message = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                     child: MaterialButton(
                       height: 45.0,
                       shape: CircleBorder(),
                      color: Colors.blue,
                       elevation: 5,
                       onPressed: () async{
                        try {
                          writeToLocalFile();
                          StorageReference storageReference = _storage.ref()
                              .child('chatMedia/')
                              .child(Path.basename(widget.media.path));
                          StorageUploadTask uploadTask = storageReference
                              .putFile(File(widget.media.path));
                          await uploadTask.onComplete;
                          uploadedFileUrl =
                          await storageReference.getDownloadURL();

                        }catch(e){
                          print(e);
                        }

                          _firestore.collection('message').add({
                            'text': message,
                            'sender': loggedInUser.email,
                            'timestamp': new DateTime.now().toUtc(),
                            'mediaUrl': uploadedFileUrl,
                          });

                         message = '';
                         Navigator.pop(context);
                       },
                       child: Icon(Icons.send, size: 30.0 ,color: Colors.white,),

                     ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  Future <String> get _localPath async{
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    return File('$path/TextMe.txt');
  }

  void writeToLocalFile() async{
   // final val =  await write();
   var image =  print(await write());
 //  print(Path.basename(image.toString()));
   //  print('done');
//     final file = await _localFile;
//     var contents = await val.readAsString();
//     print('7');
//     print(contents);
  }

  Future<File> write() async {
    final directory = await Provider.of<CustomAppBar>(context,listen: false).localFile;
    print('3');
    final imglocation = File('$directory${widget.media.path}');
    print('4');
   // imglocation.writeAsString('${widget.media.path}');
    return  imglocation;//File('$directory');
  }
}
