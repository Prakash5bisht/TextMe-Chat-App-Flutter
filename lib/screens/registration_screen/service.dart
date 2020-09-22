import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'file:///C:/Users/uday%20G/AndroidStudioProjects/test_app/lib/screens/chat_screen/chat_screen.dart';
import 'package:test_app/screens/registration_screen/verification_screen.dart';
import 'package:test_app/components/custom_alert_dialog.dart';

class Service{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(BuildContext context, String dialCode, String phoneNumber, String screenId) async{

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]){
      if(screenId == 'phone_auth_screen'){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context)=> VerificationScreen(dialCode: '+$dialCode',phoneNumber: '$phoneNumber', verificationId: verId,)
            )
        );
      }
    };

    try {
      await _auth.verifyPhoneNumber(

          phoneNumber: '+$dialCode  ' + phoneNumber,

          timeout: Duration(seconds: 30),

          verificationCompleted: (AuthCredential credential) {
            // _auth.signInWithCredential(credential).then((AuthResult result){
            //  Navigator.pushNamed(context, ChatScreen.id);
            // });
            print(credential);
          },

          verificationFailed: (AuthException exception) {
            print(exception.code);
            if(exception.code == 'quotaExceeded'){
              showAlert(context: context, alert: 'OOPS!', description: 'Too much attempts.Try again later.', defaultButtonName: 'OK' );
            }
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

  void showExceptionAsAlert(BuildContext context, PlatformException platformException){
    switch(platformException.code){
      case 'ERROR_INVALID_VERIFICATION_CODE':
        showAlert(context: context, alert: 'Invalid Code', description: 'This is not the code that we sent to you.', defaultButtonName: 'OK');
        break;
      case 'ERROR_SESSION_EXPIRED':
        showAlert(context: context, alert: 'Expired', description: 'This code has expired.Try again.', defaultButtonName: 'OK');
        break;
      default:
        showAlert(context: context, alert: 'OOPS!', description: 'Something went wrong.', defaultButtonName: 'OK');

    }
  }


  void signIn(BuildContext context, String smsOTP, String verificationId) async{

        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsOTP);

      await _auth.signInWithCredential(credential)
        .then((AuthResult result) {
                Navigator.pushNamed(context, ChatScreen.id);
              }).catchError((error){
                showExceptionAsAlert(context, error);
        });

  }

}