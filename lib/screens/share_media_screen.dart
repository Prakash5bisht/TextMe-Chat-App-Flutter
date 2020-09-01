import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/screens/media_preview_screen.dart';
import 'package:test_app/screens/testing.dart';

class ShareMediaScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: IconButton(
          icon: Icon(
            Icons.share,
            color: Color(0x99263238),
            size: 30.0,
          ),
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
                context: context,
                builder: (context){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200],
                            blurRadius: 0.2,
                            spreadRadius: 0.2,
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.camera, size: 35.0, color: Colors.blueGrey,),
                                    onPressed: (){
                                      getMedia(context, ImageSource.camera);
                                    },
                                  ),
                                ),
                                Text(
                                    'Camera',
                                  style: kShareMediaScreenTextStyle,
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.music_note, size: 35.0, color: Colors.deepOrangeAccent,),
                                    onPressed: (){
                                      print('ok');
                                    },
                                  ),
                                ),
                                Text(
                                    'Audio',
                                  style: kShareMediaScreenTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.photo, size: 35.0, color: Colors.blue[600],),
                                    onPressed: (){
                                      try{
                                        getMedia(context,ImageSource.gallery);
                                      }catch(e){
                                        print(e);
                                      }
                                    },
                                  ),
                                ),
                                Text(
                                    'Gallery',
                                    style: kShareMediaScreenTextStyle,
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.location_on, size: 35.0, color: Colors.red,),
                                    onPressed: (){
                                      print('ok');
                                    },
                                  ),
                                ),
                                Text(
                                    'Location',
                                    style: kShareMediaScreenTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.note_add, size: 35.0, color: Colors.deepPurpleAccent[100],),
                                    onPressed: (){
                                      ImagePicker().getVideo(source: ImageSource.gallery).then((video){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MediaPreviewScreen(media: video,) ));
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                    'Document',
                                    style: kShareMediaScreenTextStyle,
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.call, size: 35.0, color: Colors.lightBlue,),
                                    onPressed: (){

                                    },
                                  ),
                                ),
                                Text(
                                    'Contact',
                                    style: kShareMediaScreenTextStyle,
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                  );
                }
            );
          }
      ),
    );
  }

  void getMedia(context,mediaSource) async{
    await ImagePicker().getImage(source: mediaSource).then((image){
      if(image == null){
        print('empty selection');
      }
      else{
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MediaPreviewScreen(media: image,)));
      }
    }
    );
  }
}
