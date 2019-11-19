// Getting to the end of a list view https://stackoverflow.com/questions/43485529/programmatically-scrolling-to-the-end-of-a-listview

import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter_application/primary_widgets.dart';
import 'package:flutter_application/config.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ChatBot extends StatefulWidget {
  Config con;
  final int STATE_NORMAL = -1;
  final int STATE_OLD_MESSAGE = 1;
  final int STATE_NEW_MESSAGE = 2;
  int state;

  ChatBot({@required con});

  @override
  State createState() => ChatBotState();
}

class ChatBotState extends State<ChatBot> {
  TextEditingController controller;
  List<prefix0.Widget> widgets;
  bool waitingForPast;

  @override
  void initState() {
    widget.state = widget.STATE_NORMAL;
    controller = new TextEditingController();
    widgets = [];
    for (int i = 0; i < 40; i++) {
      widgets.add(Text("Yeehaw"));
    }
    waitingForPast = false;
  }

  @override
  Widget build(BuildContext context) {
    ListView s;
    double offset = 0;
    ScrollController scroller =
        new ScrollController(initialScrollOffset: offset);
    int state;
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

    void getPastMessage() async {
      await Future.delayed(Duration(seconds: 1));
      widgets.removeAt(0);
      widgets.insert(0, Text("Old Message"));
      waitingForPast = false;
      widget.state = widget.STATE_OLD_MESSAGE;
      setState(() {
      });
    }

    void getNewMessage() async {
      await Future.delayed(Duration(seconds: 1));
      widgets.add(Text("New message"));
      widget.state = widget.STATE_NEW_MESSAGE;
      setState(() {
      });
    }

    void nudge() async{
      await Future.delayed(Duration(milliseconds: 1));
      while(scroller.positions.isEmpty);
      if (widget.state == widget.STATE_OLD_MESSAGE) {
        scroller.animateTo(5,
            duration: Duration(milliseconds: 250), curve: Curves.easeIn);
        widget.state = widget.STATE_NORMAL;
      } else if (widget.state == widget.STATE_NEW_MESSAGE) {
        scroller.animateTo(scroller.position.maxScrollExtent + 1000,
            duration: Duration(milliseconds: 250), curve: Curves.easeIn);
        widget.state = widget.STATE_NORMAL;
      }
    }

    scroller.addListener(() {
      if (scroller.position.pixels <= 0 && !waitingForPast) {
        waitingForPast = true;
        widgets.insert(0, CircularProgressIndicator());
        setState(() {});
        getPastMessage();
      }
    });

    Widget getQuit() {
      // return getPaddedButton("Quit", () {scroller.animateTo(1000000, duration: Duration(seconds: 1), curve: Curves.bounceOut);});
      return getPaddedButton("Quit", () {
        Navigator.popUntil(this.context, ModalRoute.withName("/"));
      });
    }

    Widget getSend() {
      return FlatButton(
          onPressed: () {
            widgets.add(Text(controller.text));
            controller.clear();
            setState(() {});
            getNewMessage();
          },
          child: Icon(Icons.redo));
    }

    // https://stackoverflow.com/questions/49040679/flutter-how-to-make-a-textfield-with-hinttext-but-no-underline dealing with the underline in textformfield
    Scaffold scaff = Scaffold(
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
    nudge();
    return scaff;
  }
}
