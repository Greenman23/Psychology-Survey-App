import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_application/config.dart';
import 'package:flutter_application/Http.dart';
import 'primary_widgets.dart';

class LoginPage extends StatefulWidget {
  Config config;

  LoginPage({
    Key key,
    @required this.config,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController myController;

  TextEditingController passwordController;
  Color outComeColor;
  String loginState;

  @override
  void initState() {
    super.initState();
    myController = new TextEditingController(text: "");
    passwordController = new TextEditingController(text: "");
    myController.text = widget.config.username;
    passwordController.text = widget.config.password;
    outComeColor = Colors.black;
    loginState = "Try to login";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ListView(
        children: <Widget>[
          getTextFormField(myController, "Username", (String tex) {
            widget.config.username = tex;
          }),
          getTextFormField(passwordController, "Password", (String tex) {
            widget.config.password = tex;
          }, isPassword: true),
          getPaddedButton("Login", _loginHTTP),
          getText(loginState, color: outComeColor, fontSize: 16),
        ],
      ),
    );
  }

  void updateText(String text, Color color) {
    loginState = text;
    outComeColor = color;
    if (loginState == "Login Successful") {
      widget.config.storeGlobalConfig().then((e) {
          Navigator.popUntil(this.context, ModalRoute.withName("/"));
          setState(() {});
      });
    }
  }

  void update()
  {
    setState(() {

    });
  }

  void _loginHTTP() {
    login(widget.config, updateText, update);
  }
}
