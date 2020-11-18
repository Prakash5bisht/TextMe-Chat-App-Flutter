import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/provider/provider_class.dart';
import 'package:test_app/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/registration_screen/phone_auth_screen.dart';
import 'package:test_app/screens/welcome_screen.dart';
import 'package:test_app/screens/login_screen.dart';
import 'package:test_app/screens/registration_screen.dart';
import 'screens/launch_screen.dart';
import 'screens/registration_screen/country_picker_screen.dart';
import 'services/user_registration_status.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final _state = await UserRegistrationStatus().checkRegistrationStatus();
  runApp(TextMe(myState: _state));
}

class TextMe extends StatelessWidget {
  TextMe({@required this.myState});
  final bool myState;

  @override
  Widget build(BuildContext context) {
    var mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.black);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    return ChangeNotifierProvider(
      create: (context)=> CustomAppBar(),
      child: MaterialApp(
         initialRoute: myState == true ? ChatScreen.id : RegistrationScreen.id, //WelcomeScreen.id
        routes: {
          LaunchScreen.id: (context)=> LaunchScreen(),
          WelcomeScreen.id: (context)=> WelcomeScreen(),
          LoginScreen.id: (context)=> LoginScreen(),
          RegistrationScreen.id: (context)=> RegistrationScreen(),
          ChatScreen.id: (context)=> ChatScreen(),
          PhoneAuthentication.id: (context) => PhoneAuthentication(),
          CountryPicker.id: (context) => CountryPicker(),
//          MediaPreviewScreen.id: (context) => MediaPreviewScreen(),
          //  ShowMediaScreen.id: (context) => ShowMediaScreen(),
        },
      ),
    );
  }
}