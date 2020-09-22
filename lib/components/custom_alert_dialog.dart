import 'package:flutter/material.dart';

void showAlert(
    {
      BuildContext context,
      String alert,
      String description,
      String defaultButtonName,
      String optionalButtonName,
      Color optionalButtonColor,
      Function onPressOptionalButton
    }
      ) {
  var size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (BuildContext context){// //Text(info, style: TextStyle(color: Colors.grey[700]),),
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            // width: size.width/2,
            height: size.height/4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0, left: 8.0, right:  8.0),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(alert, style: TextStyle(color: Color(0xff525b75), fontWeight: FontWeight.w600, fontSize: 18.0),),
                            Flexible(child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                description,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xffb3aab4), fontSize: 13.0, fontWeight: FontWeight.w500),
                              ),
                            )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4.0), bottomRight: Radius.circular(4.0)),
                      color: Color(0xfff5f6f9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                              child: Text(defaultButtonName, style: TextStyle(color: Color(0xff4a5787)),),
                              onPressed: (){
                                Navigator.pop(context);
                              }
                          ),
                          SizedBox(width: 6.0,),
                          optionalButtonName != null ?
                              FlatButton(
                                color: optionalButtonColor,
                                child: Text(optionalButtonName, style: TextStyle(color: Colors.white),),
                                onPressed: onPressOptionalButton,
                              )
                              : Container()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
  );
}