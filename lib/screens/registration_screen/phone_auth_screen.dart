import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/registration_screen/country_picker_screen.dart';
import 'package:test_app/screens/registration_screen/service.dart';
import 'package:test_app/components/custom_alert_dialog.dart';

class PhoneAuthentication extends StatefulWidget {
  static const String id = 'phone_auth_screen';
  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {

  String phoneNo = '';
  String dialCode = '';
  // String smsOTP;
  // String verificationId;
  // String errorMessage = '';
 // final FirebaseAuth _auth = FirebaseAuth.instance;
  final phoneNumController = TextEditingController();
 // final dialCodeController = TextEditingController();
  FocusNode phoneField = FocusNode();
 // List<String> availableCountryCode = [];
  List<String> returnedData = [];
  String selectedCountry = 'country';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.chevron_left, color: Color(0xff263238), size: 28.0,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
                Flexible(
                // flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Welcome',
                          style: TextStyle(
                              color: Color(0xff9b9aac),
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Flexible(
                          child: Text(
                            'Fill the details to become our verified user',
                            style: TextStyle(
                              color: Color(0xff383852),
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  //flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                           // width: 200.0,
                            height: size.height/10.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 0.3, color: Color(0xffd9d9d9)),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x10263238),
                                    blurRadius: 10.0,
                                    // offset: Offset(0, 5)
                                  )
                                ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: returnedData == null || returnedData.length == 0 ? null :  AssetImage('images/${selectedCountry.toLowerCase()}.png'),
                                      radius: 15.0,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(Icons.keyboard_arrow_down, color: Color(0xff263238),),
                                      onPressed: () async{
                                        dialCode = '';
                                       try {
                                         returnedData = await Navigator.push(context, MaterialPageRoute(builder: (context)=> CountryPicker()));
                                       } catch (e) {
                                         print(e);
                                       }
                                        setState(() {
                                          if(returnedData != null){
                                            selectedCountry = returnedData[1];
                                            dialCode = returnedData[0];
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  VerticalDivider(),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '+' + dialCode,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff263238)
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      controller: phoneNumController,
                                      focusNode: phoneField,
                                      style: TextStyle(height: 1.5),
                                      onChanged: (value){
                                        phoneNo = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Phone Number',
                                        hintStyle: TextStyle(color: Colors.grey[400]),
                                        border: InputBorder.none,
                                      ),
                                      keyboardType: TextInputType.phone,
                                      cursorColor: Color(0xff263238),
                                      autofocus: true,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  //flex: 2,
                  child: Column(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        color: Color(0xff263238),
                        minWidth: 50.0,
                        height: 50.0,
                        elevation: 5.0,
                        shape: CircleBorder(),
                        child: Icon(Icons.chevron_right, color: Colors.white,),
                        onPressed: (){
                          try{
                            phoneNo.length == 0 || phoneNo.length < 10 ? showAlert(context: context, alert: 'OOPS!', description: 'Please enter a valid phone number') : dialCode.length == 0 ? showAlert(context: context, alert: 'Sorry', description: 'Please select your country') : Service().verifyPhoneNumber(context, dialCode, phoneNo, PhoneAuthentication.id);
                          }catch(e){
                            print(e);
                          }
                        },
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        'Next',
                        style: TextStyle(
                          color: Color(0xff9b9aac),
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ),
      );
  }

// Future<void> _verifyPhoneNumber(BuildContext context) async{
//
//   final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]){
//     verificationId = verId;
//   //  Navigator.push(context, MaterialPageRoute(builder: (context)=> VerificationScreen(phoneNumber: '+$dialCode $phoneNo',)));
//     print('verId: $forceCodeResend');
//     smsOTPDialog(context).then((value){
//       print('sign in');
//     });
//   };
//
//   try {
//     await _auth.verifyPhoneNumber(
//
//         phoneNumber: '+$dialCode ' + phoneNo,
//
//         timeout: Duration(seconds: 30),
//
//         verificationCompleted: (AuthCredential credential) {
//           // _auth.signInWithCredential(credential).then((AuthResult result){
//           //  Navigator.pushNamed(context, ChatScreen.id);
//           // });
//           print(credential);
//         },
//
//         verificationFailed: (AuthException exception) {
//           print(exception);
//         },
//
//         codeSent: smsOTPSent,
//
//         codeAutoRetrievalTimeout: (String verId) {
//           verificationId = verId;
//         }
//
//     );
//   }catch(e){
//     print(e);
//   }
// }

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

// void signIn() async{
//
//   try {
//     AuthCredential credential = PhoneAuthProvider.getCredential(
//         verificationId: verificationId, smsCode: smsOTP);
//     _auth.signInWithCredential(credential).then((AuthResult result) {
//       Navigator.pushNamed(context, ChatScreen.id);
//     });
//   }
//   catch(e){
//     print(e);
//   }
//
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.white,
//     body: Padding(
//       padding: EdgeInsets.symmetric(vertical: 100.0,horizontal: 20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: Text(
//                     '+',
//                     style: TextStyle(fontSize: 15.0,textBaseline: TextBaseline.alphabetic)
//                     ,textAlign: TextAlign.end,
//                   ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: TextField(
//                   controller: dialCodeController,
//                   keyboardType: TextInputType.phone,
//                   inputFormatters: [LengthLimitingTextInputFormatter(3)],//this makes max  length of dialCode  3
//                   style: TextStyle(height: 1.5),
//                   textAlign: TextAlign.center,
//                   onChanged: (value){
//                     dialCode = value;
//                   },
//                   onEditingComplete: (){
//                     availableCountryCode.contains(dialCode) ? FocusScope.of(context).requestFocus(phoneField) : _showAlert('Invalid coutry code'); // if country code is valid then on pressing done in keyboard it will pass the cursor to phone field else show alert dialog
//                   },
//                   autofocus: true,
//                 ),
//               ),
//               Expanded(
//                 child: IconButton(
//                   icon: Icon(Icons.arrow_drop_down),
//                  onPressed: () async{
//                    dialCode = await Navigator.push(context, MaterialPageRoute(builder: (context)=> CountryPicker()));
//                    dialCodeController.text = dialCode;
//                  },
//                 ),
//               ),
//               SizedBox(width: 30.0,),
//               Expanded(
//                 flex: 7,
//                 child: TextField(
//                   controller: phoneNumController,
//                   focusNode: phoneField,
//                   style: TextStyle(height: 1.5),
//                   onChanged: (value){
//                     phoneNo = value;
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Phone Number',
//                   ),
//                   keyboardType: TextInputType.phone,
//                   autofocus: true,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//           RaisedButton(
//             child: Text('Send OTP'),
//             color: Colors.blue,
//             textColor: Colors.white,
//             onPressed: () {
//               try{
//                 phoneNo.length == 0 ? _showAlert('Please enter your phone number') : dialCode.length == 0 ? _showAlert('Invalid country code length') : _verifyPhoneNumber(context);
//               }catch(e){
//                 print(e);
//               }
//             },
//           )
//         ],
//       ),
//     ),
//   );
// }
}

