import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class LoginPage extends StatefulWidget {

  String text;
  LoginPage({
    Key key,
    this.text = "asdf"
}) : super (key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController myController = new TextEditingController();
  final TextEditingController myController2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    myController.text = widget.text;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            _userNameField(),
            _passwordField(),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _userNameField() {
    return new TextFormField(
      controller: myController,
      decoration: InputDecoration(
          hintText: "Username",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12)
      ),
    );
  }

  Widget _passwordField() {
    return new TextField(
      obscureText: true,
      controller: myController2,
      decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12)
      ),
    );
  }

  Widget _submitButton(){
    return new RaisedButton(
      child: Text("Login"),
      onPressed:() => _loginHTTP(),
      color: Colors.grey,
      textColor: Colors.black,
    );
  }

  void _loginHTTP() {

    String url="http://192.168.1.139:80";

    Map map = {
      'Username' : myController.text,
      'Password' : myController2.text,
    };

    postRequest(url, map);
  }

  /*
  * This where we learned how to write post methods
  * Link: https://stackoverflow.com/questions/50278258/http-post-with-json-on-body-flutter-dart
  * */

  void postRequest(String url, Map m) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest r = await httpClient.postUrl(Uri.parse(url));
    r.headers.set('content-type', 'application/json');
    r.add(utf8.encode(json.encode(m)));
    HttpClientResponse response = await r.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    httpClient.close();
  }
}
