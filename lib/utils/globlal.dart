import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void muestraMensaje(data) {
  Fluttertoast.showToast(
      msg: data['message'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
