import 'package:flutter/cupertino.dart';

class Config {
  Config(this.username, this.password, this.actualFirstName, this.actualLastName, this.rememberPassword);

  Text username;
  Text password;
  Text actualFirstName;
  Text actualLastName;
  bool rememberPassword;
}