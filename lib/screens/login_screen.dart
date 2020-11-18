import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:test_app/components/round_button.dart';

import 'chat_screen/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id  = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//            Flexible(
//              child: Hero(
//                tag: 'logo',
//                child: Container(
//                  height: 200.0,
//                  child: Image.asset('images/logo.png'),
//                ),
//              ),
//            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: kInputFieldDecoration.copyWith(hintText: 'email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kInputFieldDecoration.copyWith(hintText: 'password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundButton(title: 'Log In', colour: Colors.lightBlueAccent,
              onPressed: () async{
                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(user != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }catch(e){
                  print(e);
                }
              },)
          ],
        ),
      ),
    );
  }
}
