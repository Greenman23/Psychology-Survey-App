import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final ShapeBorder sh = Border();

Widget getPaddedButton(String buttonText, Function functor,
    {bool isCircle: false}) {
  ShapeBorder sh;
  if (isCircle) {
    sh = CircleBorder();
  } else {
    sh = BeveledRectangleBorder();
  }
  Padding pad;
  pad = Padding(
    padding: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 30),
    child: ButtonTheme(
      minWidth: 50,
      height: 50,
      shape: sh,
      child: RaisedButton(
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 20),
        ),
        splashColor: Colors.red,
        color: Colors.cyan,
        onPressed: () {
          functor();
        },
      ),
    ),
  );

  return pad;
}

Widget getTextFormField(
    TextEditingController controller, String hint, Function(String) functor,
    {bool isPassword: false, Color color: Colors.black}) {
  return Padding(
    padding: EdgeInsets.only(top: 10, bottom: 20, left: 30, right: 30),
    child: TextField(
      controller: controller,
      onChanged: (String tex) {
        functor(tex);
      },
      style: TextStyle(color: color),
      obscureText: isPassword,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12)),
    ),
  );
}

Widget getText(String data, {double fontSize: 16, Color color: Colors.black}) {
  return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(data,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize, color: color)));
}
