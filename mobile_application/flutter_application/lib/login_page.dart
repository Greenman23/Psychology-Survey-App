import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

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
            SizedBox(height: 120),
            _userNameField(),
            SizedBox(height: 120),
            _passwordField(),
          ],
        ),
      ),
    );
  }

  Widget _userNameField() {
    return new TextField(
      decoration: InputDecoration(
        hintText: "Username",
        hintStyle: TextStyle(color: Colors.grey, fontSize: 12)
      ),
    );
  }

  Widget _passwordField() {
    return new TextField(
      decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12)
      ),
    );
  }

}