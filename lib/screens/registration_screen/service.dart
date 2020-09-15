import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app/screens/chat_screen.dart';
import 'package:test_app/screens/registration_screen/verification_screen.dart';

class Service{

  String smsOTP;
//  String errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(BuildContext context, String dialCode, String phoneNumber) async{

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> VerificationScreen(phoneNumber: '+$dialCode $phoneNumber', verificationId: verId,)));

    };

    try {
      await _auth.verifyPhoneNumber(

          phoneNumber: '+$dialCode ' + phoneNumber,

          timeout: Duration(seconds: 30),

          verificationCompleted: (AuthCredential credential) {
            // _auth.signInWithCredential(credential).then((AuthResult result){
            //  Navigator.pushNamed(context, ChatScreen.id);
            // });
            print(credential);
          },

          verificationFailed: (AuthException exception) {
            print(exception);
          },

          codeSent: smsOTPSent,

          codeAutoRetrievalTimeout: (String verId) {
          //  verificationId = verId;
          }

      );
    }catch(e){
      print(e);
    }
  }


  void signIn(BuildContext context, String smsOTP, String verificationId) async{

    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: smsOTP);
      _auth.signInWithCredential(credential).then((AuthResult result) {
        Navigator.pushNamed(context, ChatScreen.id);
      });
    }
    catch(e){
      print(e);
    }

  }
}