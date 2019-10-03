import 'package:flutter/cupertino.dart';

class Config {
  Config(this.username, this.password, this.actualFirstName, this.actualLastName, this.rememberPassword);

  String username;
  String password;
  String actualFirstName;
  String actualLastName;
  bool rememberPassword;
  bool loggedIn;
  int hash;
}