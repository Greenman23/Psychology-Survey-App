import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'Config.dart';
class LoginPage extends StatefulWidget {

  String text;
  Config config;
  LoginPage({
    Key key,
   @required this.config,
}) : super (key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController myController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    myController.text = widget.config.username.data;
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
      onChanged: (String tex){
        widget.config.username = Text(tex);
      },
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
      'Username' : 'Eric2',
      'Password' : '123456',
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
