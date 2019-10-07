import 'package:flutter/cupertino.dart';

class Config {
  Config(this.username, this.password, this.actualFirstName, this.actualLastName, this.rememberPassword, this.loggedIn);

  String username;
  String password;
  String actualFirstName;
  String actualLastName;
  String gender;
  DateTime dob;
  bool rememberPassword;
  bool loggedIn;
  int hash;
  Image img;

  void clear()
  {
    this.username = "";
    this.password = "";
    this.actualLastName = "";
    this.actualFirstName = "";
    this.gender = "Male";
    this.dob = DateTime.now();
    this.rememberPassword = false;
    this.loggedIn = false;
    this.hash = 0;
    img = null;
  }


  bool has_spaces()
  {
    if(actualFirstName.contains(" ") || actualLastName.contains(" ") || username.contains(" ") || password.contains(" "))
    {
      return true;
    }
    return false;
  }

  bool is_empty_or_null()
  {
    if(actualFirstName == "" || actualFirstName == null || actualLastName == "" || actualLastName == null
        || username == "" || username == null || password == "" || password == null)
    {
      return true;
    }

    return false;
  }

}