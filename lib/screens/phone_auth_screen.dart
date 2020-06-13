import 'package:flutter/services.dart';
import 'package:test_app/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/screens/country_picker_screen.dart';
import 'package:test_app/services/country_assets.dart';

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
  FocusNode phoneField = FocusNode();
  List<String> availableCountryCode = [];


  void initState(){
    Country country = Country();
    int length = country.countries.length;

    while(length-- >0) {
      for (var countryCode in country.countries) {
        availableCountryCode.add(countryCode["code"]);
      }
    }
    super.initState();
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async{

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]){
      verificationId = verId;
      smsOTPDialog(context).then((value){
        print('sign in');
      });
    };

    try {
      await _auth.verifyPhoneNumber(

          phoneNumber: '+$dialCode ' + phoneNo,

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 100.0,horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                      '+',
                      style: TextStyle(fontSize: 15.0,textBaseline: TextBaseline.alphabetic)
                      ,textAlign: TextAlign.end,
                    ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: dialCodeController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [LengthLimitingTextInputFormatter(3)],//this makes max  length of dialCode  3
                    style: TextStyle(height: 1.5),
                    textAlign: TextAlign.center,
                    onChanged: (value){
                      dialCode = value;
                    },
                    onEditingComplete: (){
                      availableCountryCode.contains(dialCode) ? FocusScope.of(context).requestFocus(phoneField) : _showAlert('Invalid coutry code'); // if country code is valid then on pressing done in keyboard it will pass the cursor to phone field else show alert dialog
                    },
                    autofocus: true,
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
                SizedBox(width: 30.0,),
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: phoneNumController,
                    focusNode: phoneField,
                    style: TextStyle(height: 1.5),
                    onChanged: (value){
                      phoneNo = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                    autofocus: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Text('Send OTP'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                try{
                  phoneNo.length == 0 ? _showAlert('Please enter your phone number') : dialCode.length == 0 ? _showAlert('Invalid country code length') : _verifyPhoneNumber(context);
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

