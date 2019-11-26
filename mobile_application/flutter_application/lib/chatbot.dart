// Getting to the end of a list view https://stackoverflow.com/questions/43485529/programmatically-scrolling-to-the-end-of-a-listview

import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter_application/primary_widgets.dart';
import 'package:flutter_application/config.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_application/Http.dart';

class Message {
  bool isFromBot;
  String mes;

  Message({@required isFromBot, @required mes}) {
    this.isFromBot = isFromBot;
    this.mes = mes;
  }
}

class ChatBot extends StatefulWidget {
  Config con;
  final int STATE_NORMAL = -1;
  final int STATE_OLD_MESSAGE = 1;
  final int STATE_NEW_MESSAGE = 2;
  int state;

  //ChatBot({@required con});

  ChatBot({Key key, @required this.con})
      : super(key: key);

  @override
  State createState() => ChatBotState();
}

class ChatBotState extends State<ChatBot> {
  TextEditingController controller;
  List<Message> widgets;
  bool waitingForPast;

  @override
  void initState() {
    widget.state = widget.STATE_NORMAL;

    controller = new TextEditingController();
    widgets = [];
    waitingForPast = false;
  }

  @override
  Widget build(BuildContext context) {
    ListView s;
    double offset = 0;
    ScrollController scroller =
        new ScrollController(initialScrollOffset: offset);
    int state;

    Widget getMessageBubble(Message message) {
      double paddingVal = 0;
      Color background = Colors.blue;
      if (message.isFromBot) {
        paddingVal = 50;
        background = Colors.green;
      }
      return Padding(
        padding: EdgeInsets.only(right: paddingVal),
        child: Container(
          width: 300,

          child: Align(alignment: Alignment.bottomRight, heightFactor: .9, child: Text(
            message.mes,
            style: TextStyle(fontSize: 22 ),
          )),
          decoration: BoxDecoration(
              color: background,
              border: Border.all(color: background),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5)),
        ),
      );
    }

    Widget getListView() {
      int itemCount = widgets.length;
      if (waitingForPast) {
        itemCount += 1;
      }
      s = ListView.builder(
          key: new Key("abcde"),
          itemExtent: 50,
          itemCount: itemCount,
          controller: scroller,
          itemBuilder: (BuildContext context, int index) {
            if (waitingForPast) {
              if (index == 0) {
                return CircularProgressIndicator();
              } else {
                return Center(child: getMessageBubble(widgets[index]));
              }
            } else {
              return Center(child: getMessageBubble(widgets[index]));
            }
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

    // Call back for getting old messages here
    void getPastMessage() async {
      await Future.delayed(Duration(seconds: 1));
      widgets.insert(0, Message(isFromBot: false, mes: "Hello friend"));
      waitingForPast = false;
      widget.state = widget.STATE_OLD_MESSAGE;
      setState(() {});
    }

    // Callback for getting replies here
    void getNewMessage(String msg) async {
      //await Future.delayed(Duration(seconds: 1));
      String response = await chatBotResponse(widget.con, msg);
      widgets.add(Message(isFromBot: true, mes: response));
      widget.state = widget.STATE_NEW_MESSAGE;
      setState(() {});
    }

    void nudge() async {
      await Future.delayed(Duration(milliseconds: 1));
      while (scroller.positions.isEmpty);
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
            String user_message = controller.text;
            print(user_message);
            widgets.add(Message(isFromBot: false, mes: controller.text));
            controller.clear();
            setState(() {});
            getNewMessage(user_message);
          },
          child: Icon(Icons.redo));
    }

    // https://stackoverflow.com/questions/49040679/flutter-how-to-make-a-
    // textfield-with-hinttext-but-no-underline dealing with the underline in
    // textformfield
    Scaffold scaff = Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Stack(children: <Widget>[
              Column(
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