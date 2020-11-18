import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'chat_screen/chat_screen.dart';
import 'welcome_screen.dart';
import 'dart:io';

class LaunchScreen extends StatefulWidget {
  static const String id = 'launch_screen';
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {

  @override
  void initState() {
    checkRegistrationStatus();
    super.initState();
  }

  void checkRegistrationStatus() async{
    final File _status = await _statusFile;
    final String content = await _status.readAsString();
    if(content == 'true'){
      Navigator.pushNamed(context, ChatScreen.id);
    }
    else{
      Navigator.pushNamed(context, WelcomeScreen.id);
    }
  }

  Future<String> get _path async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
}

  Future<File> get _statusFile async{
    final path = await  _path;
    return File('$path/TextMe.txt');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.chat_bubble,
          size: 50.0,
          color: Color(0xff263238)
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }
}
