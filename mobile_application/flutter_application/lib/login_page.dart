import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'Config.dart';
import 'Http.dart';
import 'primary_widgets.dart';

class LoginPage extends StatefulWidget {

  Config config;
  LoginPage({
    Key key,
   @required this.config,
}) : super (key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

}


class _LoginPageState extends State<LoginPage> {
  TextEditingController myController ;
  TextEditingController passwordController;
  Color outComeColor;
  @override
  void initState()
  {
    super.initState();
    myController = new TextEditingController(text: "");
    passwordController = new TextEditingController(text: "");
    myController.text = widget.config.username;
    passwordController.text = widget.config.password;
    outComeColor = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            getTextFormField(myController, "Username", (String tex){widget.config.username = tex;}),
            getTextFormField(passwordController, "Password", (String tex){widget.config.password = tex;}, isPassword: true),
            getPaddedButton("Login", _loginHTTP),
            getText(widget.config.loginState, color: outComeColor, fontSize: 16),
          ],
        ),
      ),
    );
  }

  void updateText(String text, Color color)
  {
    widget.config.loginState = text;
    outComeColor = color;
    setState(() {
    });
  }


  void _loginHTTP()
  {
    login(widget.config, updateText);
  }

  // This was an example from stack overflow
  //https://stackoverflow.com/questions/50278258/http-post-with-json-on-body-flutter-dart
  void postRequest(String url, Map m) async
  {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest r = await httpClient.postUrl(Uri.parse(url));
    r.headers.set('content-type', 'application/json');
    r.add(utf8.encode(json.encode(m)));
    HttpClientResponse response = await r.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
  }
}
