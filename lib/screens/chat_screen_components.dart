import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton({this.iconData,this.iconColor,this.highlightColor,this.splashColor, this.function});
  final IconData iconData;
  final Color iconColor;
  final Color highlightColor;
  final Color splashColor;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 5.0,
      height: 5.0,
      elevation: 0.0,
      color: Colors.white,
      highlightColor: highlightColor,
      splashColor: splashColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Icon(
        iconData,
        size: 22.0,
        color: iconColor,
      ),
      onPressed: function,
    );
  }
}
