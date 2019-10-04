import 'package:flutter/cupertino.dart';

class Config {
  Config(this.username, this.password, this.actualFirstName, this.actualLastName, this.rememberPassword, this.loginState);

  String username;
  String password;
  String actualFirstName;
  String actualLastName;
  String loginState;
  String gender;
  DateTime dob;
  bool rememberPassword;
  bool loggedIn;
  int hash;
}