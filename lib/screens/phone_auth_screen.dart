import 'package:test_app/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/screens/country_picker_screen.dart';

class PhoneAuthentication extends StatefulWidget {
  static const String id = 'phone_auth_screen';
  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {

  String phoneNo = '';
  String dialCode = '';
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final phoneNumController = TextEditingController();
  final dialCodeController = TextEditingController();

  Future<void> _verifyPhoneNumber(BuildContext context) async{

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]){
      verificationId = verId;
      smsOTPDialog(context).then((value){
        print('sign in');
      });
    };

    try {
      await _auth.verifyPhoneNumber(

          phoneNumber: dialCode + '' + phoneNo,

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
            verificationId = verId;
          }

      );
    }catch(e){
      print(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context){
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return new AlertDialog(
            title: Text('Enter OTP'),
            content: Container(
              height: 85,
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value){
                      smsOTP = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: (){
                  signIn();
                },
              )
            ],
          );
        }
    );
  }


  void _showAlert(String info){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content:  Text(info),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

//handleError(PlatformException error){
//    print(error);
//    switch (error.code){
//      case 'ERROR_INVALID_VERIFICATION_CODE':
//      FocusScope.of(context).requestFocus(new FocusNode());
//      setState(() {
//        errorMessage = 'Invalid Code';
//      });
//      Navigator.of(context).pop();
//      smsOTPDialog(context).then((value){
//        print('sign in');
//      });
//      break;
//      default: setState((){
//        errorMessage = error.message;
//      });
//      break;
//    }
//}

  void signIn() async{

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 150.0,horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: dialCodeController,
                    onChanged: (value){
                      dialCode = value;
                    },
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                   onPressed: () async{
                     dialCode = await Navigator.push(context, MaterialPageRoute(builder: (context)=> CountryPicker()));
                     dialCodeController.text = dialCode;
                   },
                  ),
                ),
                SizedBox(width: 5.0,),
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: phoneNumController,
                    onChanged: (value){
                      phoneNo = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            FlatButton(
              child: Text('Send OTP'),
              onPressed: () {
                try{
                  phoneNo.length == 0 ? _showAlert('Please enter your phone number') :  _verifyPhoneNumber(context);
                }catch(e){
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

