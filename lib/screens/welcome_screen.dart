import 'package:test_app/screens/phone_auth_screen.dart';
import 'package:test_app/screens/login_screen.dart';
import 'package:test_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:test_app/components/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    controller.forward();

    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);

    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                  Text(
                    'Flash Chat',
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundButton(title: 'Log In', colour: Colors.lightBlueAccent,onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },),
              RoundButton(title: 'Register', colour: Colors.blueAccent, onPressed: (){
                Navigator.pushNamed(context, PhoneAuthentication.id);
              },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

