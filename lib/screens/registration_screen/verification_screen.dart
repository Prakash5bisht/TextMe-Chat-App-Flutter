import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/screens/registration_screen/service.dart';
import 'dart:async';

import 'package:test_app/components/custom_alert_dialog.dart';

class VerificationScreen extends StatefulWidget {
  VerificationScreen({this.phoneNumber,this.verificationId, this.dialCode});
  static const String id = 'verification_screen';

  final String phoneNumber;
  final String verificationId;
  final String dialCode;
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Timer _timer;
  int _start = 30;
  final otpFieldController = TextEditingController();


  @override
  void initState() {
    startOtpValidationTimer();
    super.initState();
  }
  void startOtpValidationTimer(){
    _start = 30;
    const oneSecond = const Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSecond,
            (timer) =>  setState(() {
              if(_start < 1){
                _start = 00;
                timer.cancel();
              }
              else{
                _start = _start - 1;
              }
            }) );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.chevron_left, size: 28.0,),
                  color: Color(0xff263238),
                  onPressed: (){
                   Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Verification', style: TextStyle(color: Color(0xff70768a), fontWeight: FontWeight.w600, fontSize: 18.0),),
                      SizedBox(height: 8.0,),
                      Flexible(
                        child: Text(
                          'We sent you an SMS code',
                          style: TextStyle(
                            color: Color(0xff393d48),
                            fontWeight: FontWeight.w600,
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.0,),
                      Row(
                        children: <Widget>[
                          Text('Phone number:', style: TextStyle(color: Color(0xff70768a), fontWeight: FontWeight.w600),),
                          SizedBox(width: 5.0,),
                          Text(widget.dialCode, style: TextStyle(color: Color(0xff599ae0), fontWeight: FontWeight.w500),),
                          SizedBox(width: 5.0,),
                          Text(widget.phoneNumber, style: TextStyle(color: Color(0xff599ae0), fontWeight: FontWeight.w500),),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     Flexible(
                       child: Container(
                         width: size.width/2.0,
                         child: Theme(
                           data: ThemeData(primaryColor: Color(0xff263238)),
                           child: TextField(
                             controller: otpFieldController,
                             autofocus: true,
                             keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                             cursorColor: Color(0xff263238),
                             textAlign: TextAlign.center,
                             inputFormatters: [LengthLimitingTextInputFormatter(6)],
                             style: TextStyle(
                               color: Colors.grey[700],
                               fontSize: 25.0
                             ),
                           ),
                         ),
                       ),
                     ),
                     Text(
                        _start>9 ? '00:$_start' : '00:0$_start',
                       style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w500),
                     )
                   ],
                 ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      height: 45.0,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      color: Color(0xff263238),
                      child: Text('Verify', style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        otpFieldController.text == null || otpFieldController.text == '' ? showAlert(context: context, alert: 'Uh oh!', description: 'Please enter the OTP') :
                      Service().signIn(context, otpFieldController.text, widget.verificationId);
                      },
                    ),
                    SizedBox(height: 6.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Didn\'t received code?', style: TextStyle(color: Color(0xff9b9aac), fontWeight: FontWeight.w500),),
                        FlatButton(
                          child: Text('Resend' , style: TextStyle(color: _start >= 1 ? Colors.grey : Color(0xff6161d1), fontWeight: FontWeight.w500),),
                          onPressed: _callServiceClass// _start > 1 ? null : startOtpValidationTimer,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _callServiceClass(){
    if(_start == 0){
      Service().verifyPhoneNumber(context, widget.dialCode, widget.phoneNumber, VerificationScreen.id);
      otpFieldController.clear();
      startOtpValidationTimer();
    }
  }
}
