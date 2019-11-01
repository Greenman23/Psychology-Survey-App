import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application/Http.dart';

class Config {
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

//  Future<int> storeConfig({bool loggedin = true})  async {
//    Map map = new Map();
//        map["username"] = this.username;
//        map["password"] = this.password;
//        map["actualLastName"] = this.actualLastName;
//        map["actualFirstName"] = this.actualFirstName;
////    map["gender"] = this.gender;
////    map["dob"] = this.dob;
//         map["rememberPassword"] = this.rememberPassword;
//         map['loggedin'] = this.loggedIn & loggedin;
//         // map["hash"] = this.hash;
//         map["path"] = this.path;
//         map["locData"] = this.locData;
//         String json = jsonEncode(map);
//         await getApplicationDocumentsDirectory().then((onValue) {
//             String p = join(onValue.path, this.username);
//             File con = File(p);
//             if (con.existsSync()) {
//               con.writeAsStringSync(json);
//             } else {
//               con.createSync();
//               con.openWrite();
//               con.writeAsStringSync(json);
//             }
//             String q = join(onValue.path, GLOBAL);
//             File con2 = File(q);
//             if (con2.existsSync()) {
//               con2.writeAsStringSync(json);
//             } else {
//               con2.createSync();
//               con2.openWrite();
//               con2.writeAsStringSync(json);
//             }
//             return 0;
//    });
//    return 6;
//  }
//
//  Future<int> fillConfig() async  {
//    int x = 2;
//    x+=1;
//
//    await getApplicationDocumentsDirectory().then((onValue) {
//      String p = join(onValue.path, this.username);
//      File con = File(p);
//      if (con.existsSync()) {
//        String j = con.readAsStringSync();
//        Map map = jsonDecode(j);
//        this.username = map["username"];
//        this.password = map["password"];
//        this.actualLastName = map["actualLastName"];
//        this.actualFirstName = map["actualFirstName"];
//        var loggedIn = map['loggedin'];
//        if(loggedIn != null)
//          {
//            this.loggedIn = map['loggedin'];
//          }
//
////        this.gender = map["gender"];
////        this.dob = map["dob"];
//        this.rememberPassword = map["rememberPassword"];
////        this.hash = map["hash"];
//        this.path = map["path"];
//        this.locData = map["locData"];
//      }
//      return 0;
//    });
//    return 7;
//  }

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
      map["actualLastName"] = this.actualLastName;
      map["actualFirstName"] = this.actualFirstName;
      map["rememberPassword"] = this.rememberPassword;
      map["path"] = this.path;
      map["locData"] = this.locData;

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
