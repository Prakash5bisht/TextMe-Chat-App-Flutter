import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/screens/media_preview_screen.dart';

class ShareMediaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  IconButton(
        icon: Icon(
          Icons.add_circle,
          color: Colors.blue,
          size: 43.0,
        ),
        onPressed: () {
          showBottomSheet(
            backgroundColor: Colors.transparent,
              context: context,
              builder: (context){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 10,
                          spreadRadius: 3,
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.camera, size: 35.0, color: Color(0xff003366),),
                                onPressed: (){
                                  getMedia(context, ImageSource.camera);
                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.photo, size: 35.0, color: Colors.lightBlue,),
                                onPressed: (){
                                  getMedia(context,ImageSource.gallery);
                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.note_add, size: 35.0, color: Colors.deepPurpleAccent[100],),
                                onPressed: (){

                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.music_note, size: 35.0, color: Colors.deepOrangeAccent,),
                                onPressed: (){

                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.location_on, size: 35.0, color: Colors.red,),
                                onPressed: (){

                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.call, size: 35.0, color: Colors.lightBlue,),
                                onPressed: (){

                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ),
                );
              }
          );
        }
    );
  }

  void getMedia(context,mediaSource) async{
    await ImagePicker().getImage(source: mediaSource).then((image){
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MediaPreviewScreen(media: image,)));
    }
    );
  }
}
