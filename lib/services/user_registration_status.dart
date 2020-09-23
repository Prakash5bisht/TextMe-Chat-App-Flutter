import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserRegistrationStatus{

  Future<String> get _path async{
    final _directory = await getApplicationDocumentsDirectory();
    print(_directory);
    return _directory.path;
  }

  Future<File> get _statusFile async{
    final _statusFilePath = await  _path;

    if(await File('$_statusFilePath/TextMe.txt').exists()){
      return File('$_statusFilePath/TextMe.txt');
    }
    else{
      File('$_path/TextMe.txt').writeAsString('false');
      return File('$_statusFilePath/TextMe.txt');
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