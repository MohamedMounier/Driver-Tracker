import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToasts {
  static Future<bool?> errorToast (String message)async{
    return await Fluttertoast.showToast(
      msg: message,
      textColor: Colors.red,
      backgroundColor: Colors.white,
    );
  }

  static Future<bool?> successToast (String message)async{
    return await Fluttertoast.showToast(
      msg: message,
      textColor: Colors.green,
      backgroundColor: Colors.white,
    );
  }
}