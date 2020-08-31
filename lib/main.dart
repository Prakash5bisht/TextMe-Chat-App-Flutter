import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/models/custom_appbar.dart';
import 'package:test_app/screens/country_picker_screen.dart';
import 'package:test_app/screens/phone_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/welcome_screen.dart';
import 'package:test_app/screens/login_screen.dart';
import 'package:test_app/screens/registration_screen.dart';
import 'package:test_app/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.black );
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    return ChangeNotifierProvider(
      create: (context)=> CustomAppBar(),
      child: MaterialApp(
        initialRoute: WelcomeScreen.id,
        routes: {
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