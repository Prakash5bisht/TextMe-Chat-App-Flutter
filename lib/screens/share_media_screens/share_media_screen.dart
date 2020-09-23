import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_app/constants.dart';
import 'package:test_app/custom_icons_set_icons.dart';
import 'package:test_app/screens/registration_screen/phone_auth_screen.dart';
import 'package:test_app/screens/share_media_screens/reusable_media_button.dart';
import 'package:test_app/screens/share_media_screens/media_preview_screen.dart';
class ShareMediaScreen extends StatefulWidget {

  @override
  _ShareMediaScreenState createState() => _ShareMediaScreenState();
}

class _ShareMediaScreenState extends State<ShareMediaScreen> {

  bool isPressed = false;
  Color color = Color(0xff060607);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: IconButton(
          splashColor: Color(0xffc6d0d2),
          highlightColor: Color(0xffc6d0d2),
          icon: Icon(
            CustomIconsSet.share_social_interface_button,
            color: Color(0xff525260),//Color(0xff667a7e),//Color(0x99263238),
            size: 27.0,
          ),
          onPressed: () async{
            // File file = await _statusFile;
            // file.delete();
            // print('done');
           // Navigator.pushNamed(context, PhoneAuthentication.id);
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
                        padding: const EdgeInsets.only(bottom: 30.0, top: 18.0),
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Expanded(
                                  child: ReusableButton(
                                    highlightColor: Color(0xffd1cffc),
                                    splashColor: Color(0xffd1cffc),
                                    iconData: CustomIconsSet.photo_camera_outline,
                                    iconColor: Colors.deepPurpleAccent,
                                    function: (){// getMedia(context, ImageSource.camera);
                                    },
                                  ),
                                ),
                                Text(
                                    'Camera',
                                  style: kShareMediaScreenTextStyle,
                                ),
                                Expanded(
                                  child: ReusableButton(
                                    splashColor: Color(0xffffd8cc),
                                    highlightColor: Color(0xffffd8cc),
                                    iconData: CustomIconsSet.headphones_audio_symbol,//Colors.deepOrangeAccent
                                    iconColor: Colors.deepOrangeAccent,
                                     function: (){
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
                                  child: ReusableButton(
                                    splashColor: Color(0xffc5eded),
                                    highlightColor: Color(0xffc5eded),
                                    iconData: CustomIconsSet.images_square_outlined_interface_button_symbol,//Colors.blue[600]
                                    iconColor: Color(0xff009772),
                                    function: (){
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
                                  child: ReusableButton(
                                    highlightColor: Color(0xfffed4cd),
                                    splashColor: Color(0xfffed4cd),
                                    iconData: CustomIconsSet.big_map_placeholder_outlined_symbol_of_interface,  //Colors.red
                                    iconColor: Color(0xfffc2315),
                                    function: (){
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
                                  child: ReusableButton(
                                    splashColor: Color(0xfffddaa2),
                                    highlightColor: Color(0xfffeebcd),
                                    iconData: CustomIconsSet.file_rounded_outlined_symbol, //Colors.deepPurpleAccent[100]
                                    iconColor: Color(0xfffaa61e),
                                    function: (){
                                      // ImagePicker().getVideo(source: ImageSource.gallery).then((video){
                                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => MediaPreviewScreen(media: video,) ));
                                      // });
                                    },
                                  ),
                                ),
                                Text(
                                    'Document',
                                    style: kShareMediaScreenTextStyle,
                                ),
                                Expanded(
                                  child: ReusableButton(
                                    splashColor: Color(0xffcdd0fe),
                                    highlightColor: Color(0xffcdd0fe),
                                    iconData: CustomIconsSet.phone_auricular_outline,  //Colors.lightBlue
                                    iconColor: Color(0xff2735fb),
                                    function: (){

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

Future<String> get _path async{
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    return directory.path;
  }

  Future<File> get _statusFile async{
    final path = await  _path;
    return File('$path/TextMe.txt');
  }

  void getMedia(context,mediaSource) async{
    await ImagePicker().getImage(source: mediaSource).then((image){
      if(image == null){
        return;
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
