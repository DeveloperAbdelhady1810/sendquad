import 'package:flutter/material.dart';

class Styles{
  TextStyle style(double fontSize,Color textColor,bool isBold,{FontStyle style = FontStyle.normal}){
    return TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: isBold?FontWeight.bold:FontWeight.normal,
      fontStyle: style,
      
    );
  }
  buttonStyle(Color? backgroundColor, Color? overlayColor, double borderRaduis,{Color bordersidecolor = Colors.white}){
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(backgroundColor),
      overlayColor: WidgetStateProperty.all(overlayColor),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRaduis),side: BorderSide(color:bordersidecolor,width: 3)))
      
    );
  }
}