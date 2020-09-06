import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserRegistrationStatus{

  Future<String> get _path async{
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    return directory.path;
  }

  Future<File> get _statusFile async{
    final path = await  _path;

    if(await File('$path/TextMe.txt').exists()){
      return File('$path/TextMe.txt');
    }
    else{
      File('$path/TextMe.txt').writeAsString('false');
      return File('$path/TextMe.txt');
    }
  }

  Future<bool> checkRegistrationStatus() async{
    final File _status = await _statusFile;
    final String _content = await _status.readAsString();
    print(_content);
    if(_content == 'true'){
      print(_content);
      return true;
    }
    else{
      return false;
    }
  }
}