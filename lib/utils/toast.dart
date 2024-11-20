import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

successToast(String message) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

warningToast(String message) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.amber,
    textColor: Colors.black,
    fontSize: 14.0,
  );
}

errorToast(String message) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

infoToast(String message) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blueGrey,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
