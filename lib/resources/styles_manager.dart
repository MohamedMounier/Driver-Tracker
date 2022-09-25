

import 'package:flutter/material.dart';
import 'color_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color){
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight
    ,color: color,
  );
}
TextStyle getRegularTextStyle({double fontSize=12, Color? color}){
  return _getTextStyle(fontSize,
      FontWeight.normal,
      ColorManager.grey );
}
TextStyle getBodyLargeTextStyle({double fontSize=18.0, Color? color}){
  return _getTextStyle(fontSize,
     FontWeight.w600,
      color??ColorManager.grey );
}
TextStyle getBodyMedium({double fontSize=16.0, Color? color}){
  return _getTextStyle(fontSize,
      FontWeight.bold,
      ColorManager.grey );
}
// headline text style
TextStyle getLargeColoredTitle({double fontSize=22.0, Color? color}){
  return TextStyle(fontSize: fontSize,
    fontWeight:  FontWeight.normal,
     color:  Colors.deepPurple,
  fontStyle: FontStyle.italic
  );
}

TextStyle getMediumTextStyle({double fontSize=12.0, Color? color}){
  return _getTextStyle(fontSize,
      FontWeight.w400,
      ColorManager.darkPrimary);
}
TextStyle getSemiBoldTextStyle({double fontSize=12.0,required Color color}){
  return _getTextStyle(fontSize,
      FontWeight.w500,
      color);
}
