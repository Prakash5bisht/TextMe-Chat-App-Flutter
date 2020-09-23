import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class ShowMediaScreen extends StatelessWidget {
  static const String id = 'show_media_screen';
  ShowMediaScreen({@required this.mediaLink});

  final String mediaLink;

  void changeOverlay(){
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: (){
            changeOverlay();
          },
          child: Container(
            child: PhotoView(
              imageProvider: NetworkImage(mediaLink),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: 2.0,
            ),
          ),
        ),
      )
    );
  }
}
