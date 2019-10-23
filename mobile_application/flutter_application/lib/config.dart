import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Config  {
  Config(this.username, this.password, this.actualFirstName,
      this.actualLastName, this.rememberPassword, this.loggedIn) {
    this.path = "";
  }


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
  Map locData;
  String path;

  void clear() {
    this.username = "";
    this.password = "";
    this.actualLastName = "";
    this.actualFirstName = "";
    this.gender = "Male";
    this.dob = DateTime.now();
    this.rememberPassword = false;
    this.loggedIn = false;
    this.hash = 0;
    this.path = "";
    img = null;
    this.locData = null;
  }

  bool has_spaces() {
    if (actualFirstName.contains(" ") ||
        actualLastName.contains(" ") ||
        username.contains(" ") ||
        password.contains(" ")) {
      return true;
    }
    return false;
  }

  bool is_empty_or_null() {
    if (actualFirstName == "" ||
        actualFirstName == null ||
        actualLastName == "" ||
        actualLastName == null ||
        username == "" ||
        username == null ||
        password == "" ||
        password == null) {
      return true;
    }

    return false;
  }

  Future<int> storeConfig()  async {
    Map map = new Map();
    map["username"] = this.username;
    map["password"] = this.password;
    map["actualLastName"] = this.actualLastName;
    map["actualFirstName"] = this.actualFirstName;
//    map["gender"] = this.gender;
//    map["dob"] = this.dob;
    map["rememberPassword"] = this.rememberPassword;
   // map["hash"] = this.hash;
    map["path"] = this.path;
    map["locData"] = this.locData;
    this.actualLastName = "ff1";
    String json = jsonEncode(map);
    this.actualLastName = "ff2";
    await getApplicationDocumentsDirectory().then((onValue) {
      this.actualLastName = "ff3";
      String p = join(onValue.path, this.username);
      File con = File(p);
      if (con.existsSync()) {
        this.actualLastName = "ff4";
        con.writeAsStringSync(json);
        this.actualLastName = "ff5";
      } else {
        con.createSync();
        this.actualLastName = "ff6";
        con.openWrite();
        this.actualLastName = "ff7";
        con.writeAsStringSync(json);
        this.actualLastName = "ff8";
      }
      return 0;
    });
    return 6;
  }

  Future<int> fillConfig() async  {
    int x = 2;
    x+=1;
    this.actualLastName = "sdsad";
    this.actualLastName = "sdsad1.5";
    await getApplicationDocumentsDirectory().then((onValue) {
      this.actualLastName = "sdsad2";
      String p = join(onValue.path, this.username);
      File con = File(p);
      this.actualLastName = "sdsad2.5";
      if (con.existsSync()) {
        this.actualLastName = "sdsad3";
        String j = con.readAsStringSync();
        Map map = jsonDecode(j);
        this.username = map["username"];
        this.password = map["password"];
        this.actualLastName = map["actualLastName"];
        this.actualFirstName = map["actualFirstName"];
//        this.gender = map["gender"];
//        this.dob = map["dob"];
        this.rememberPassword = map["rememberPassword"];
        this.actualLastName = "sdsad4";
//        this.hash = map["hash"];
        this.path = map["path"];
        this.locData = map["locData"];
      }
      return 0;
    });
    return 7;
  }
}
