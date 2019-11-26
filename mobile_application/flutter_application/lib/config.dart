import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application/Http.dart';

class Config {
  Config(this.username, this.password, this.actualFirstName,
      this.actualLastName, this.email,
      this.address, this.phone,this.rememberPassword, this.loggedIn) {
    this.path = "";
  }

  String username;
  String password;
  String actualFirstName;
  String actualLastName;
  String smoker;
  String education;
  String email;
  String address;
  String phone;
  String race;
  String gender;
  DateTime dob;
  bool rememberPassword;
  bool loggedIn;
  int hash;
  Image img;
  Map locData;
  String path;
  String income;

  void clear() {
    this.username = "";
    this.password = "";
    this.actualLastName = "";
    this.actualFirstName = "";
    this.gender = "Male";
    this.dob = DateTime.now();
    this.smoker="No";
    this.education="Bachelors";
    this.email="";
    this.address="";
    this.phone="";
    this.race="White";
    this.rememberPassword = false;
    this.loggedIn = false;
    this.hash = 0;
    this.path = "";
    img = null;
    this.locData = null;
    income = "";
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


  final String GLOBAL = "xyzGLOBALxyz";

  Future<int> getGlobalConfig(Function func) async {
    await getApplicationDocumentsDirectory().then((onValue) {
      String p = join(onValue.path, GLOBAL);
      File con = File(p);
      if (con.existsSync()) {
        String j = con.readAsStringSync();
        Map map = jsonDecode(j);
        this.username = map["username"];
        this.password = map["password"];
        this.path = map["path"];
        login(this, (String, Color){func();}, func);
      }
      return 0;
    });
    return 7;
  }

  Future<int> storeGlobalConfig() async {
    await getApplicationDocumentsDirectory().then((onValue) {
      String p = join(onValue.path, GLOBAL);
      Map map = Map();
      map["username"] = this.username;
      map["password"] = this.password;
      map["path"] = this.path;

      File con = File(p);
      if (con.existsSync()) {
        con.writeAsStringSync(jsonEncode(map));
      } else {
        con.createSync();
        con.writeAsStringSync(jsonEncode(map));
      }
      return 0;
    });
    return 7;
  }

  Future<int> clearGlobalConfig() async {
    await getApplicationDocumentsDirectory().then((onValue) {
      String p = join(onValue.path, GLOBAL);
      Map map;
      map["username"] = "";
      map["password"] = "";
      map["actualLastName"] = "";
      map["actualFirstName"] = "";
      map["rememberPassword"] = false;
      map["path"] = "";
      map["locData"] = "";

      File con = File(p);
      if (con.existsSync()) {
        con.writeAsStringSync(jsonEncode(map));
      } else {
        con.createSync();
        con.writeAsStringSync(jsonEncode(map));
      }
      return 0;
    });
    return 7;
  }
}
