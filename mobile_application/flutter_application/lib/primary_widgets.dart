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

Widget getPhoneFormField(
    TextEditingController controller, String hint, Function(String) functor,
    {bool isPassword: false, Color color: Colors.black}) {
  return Padding(
    padding: EdgeInsets.only(top: 10, bottom: 20, left: 30, right: 30),
    child: TextField(
      keyboardType: TextInputType.phone,
      maxLength: 15,
      controller: controller,
      onChanged: (String num) {
        functor(num);
      },
      style: TextStyle(color: color),
      obscureText: isPassword,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12)),
    ),
  );
}


Widget getMoneyFormField(
    TextEditingController controller, String hint, Function(String) functor,
    {bool isPassword: false, Color color: Colors.black}) {
  return Padding(
    padding: EdgeInsets.only(top: 10, bottom: 20, left: 30, right: 30),
    child: TextFormField(

      validator: (value){
        if(value[0] != '\$')
          {
            return ":\$" + value;
          }
        return value;
      },
      keyboardType: TextInputType.numberWithOptions(),
      maxLength: 15,
      controller: controller,
      onChanged: (String num) {
        int offset = controller.selection.extent.offset;
        functor(num);
        if(controller.text.length < offset)
          {
            offset = controller.text.length;
          }
        controller.selection = TextSelection.collapsed(offset:offset);
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


Widget getQuestionAnswer(String question, String answer)
{
  return Padding(padding: EdgeInsets.all(5), child: Container(
      decoration: BoxDecoration(border: Border.all(width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 5, top: 5),
              child: Container(
                child: Text("Question:\t" + question),
                decoration: BoxDecoration(
                    border: Border.all(width: .5),
                    color: Colors.green),
              )),
          //Container(child:Text("Answer:\t" + answer['Answer']), color: Colors.blue,),
          Padding(
              padding: EdgeInsets.only(
                  left: 25, right: 5, top: 5),
              child: Container(
                child: Text("Answer:\t" + answer),
                decoration: BoxDecoration(
                    border: Border.all(width: .5),
                    color: Colors.blue),
              )),
          Divider(),
        ],
      )));
}