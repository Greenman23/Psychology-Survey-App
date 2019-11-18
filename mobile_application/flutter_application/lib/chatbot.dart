// Getting to the end of a list view https://stackoverflow.com/questions/43485529/programmatically-scrolling-to-the-end-of-a-listview

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter_application/primary_widgets.dart';
import 'package:flutter_application/config.dart';

class ChatBot extends StatefulWidget {
  Config con;

  ChatBot({@required con});

  @override
  State createState() => ChatBotState();
}

class ChatBotState extends State<ChatBot> {
  TextEditingController controller;
  int count;
  List<prefix0.Widget> widgets;

  @override
  void initState() {
    controller = new TextEditingController();
    count = 10;
    widgets = [Text("")];

  }

  @override
  Widget build(BuildContext context) {
    ListView s;
    ScrollController scroller = new ScrollController();
    String text = "not cool ";

    int getItemCount() {
      return count;
    }

    Widget getListView() {
      s = ListView.builder(
          key: new Key("abcde"),
          itemExtent: 50,
          itemCount: widgets.length,
          controller: scroller,
          itemBuilder: (BuildContext context, int index) {
            return Center(child: widgets[index]);
          });
      return s;
    }

    Widget getMessage() {
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              style: BorderStyle.solid,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration.collapsed(hintText: "Send a message"),
          ),
        ),
      );
    }

    scroller.addListener((){
      if(scroller.position.pixels <= 0)
        {
          int y = 3;
          widgets.insert(0,CircularProgressIndicator() );
          setState(() {

          });
        }
    });

    Widget getQuit() {
      // return getPaddedButton("Quit", () {scroller.animateTo(1000000, duration: Duration(seconds: 1), curve: Curves.bounceOut);});
      return getPaddedButton("Quit", () {
        scroller.animateTo(scroller.position.maxScrollExtent,
            duration: Duration(milliseconds: 1 * getItemCount()),
            curve: Curves.ease);
        for (int i = 0; i < 1; i++) {
          widgets.add(Text("not vool"));
          widgets.insert(0, Text("Cooler"));
        }
        setState(() {
          scroller.animateTo((scroller.position.maxScrollExtent - 0),
              duration: Duration(seconds: 1), curve: Curves.ease);
        });
      });
    }

    Widget getSend() {
      return FlatButton(onPressed: () {}, child: Icon(Icons.redo));
    }


    // https://stackoverflow.com/questions/49040679/flutter-how-to-make-a-textfield-with-hinttext-but-no-underline dealing with the underline in textformfield
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Stack(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: getListView()),
                  Row(
                    children: <Widget>[
                      Expanded(child: getMessage()),
                      getSend()
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: getQuit(),
              )
            ])));
  }
}
