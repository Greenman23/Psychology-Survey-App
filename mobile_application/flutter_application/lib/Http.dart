import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application/chatbot.dart';
import 'package:flutter_application/survey_list.dart';
import 'package:flutter_application/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:steel_crypt/steel_crypt.dart';
import 'package:flutter_application/encryption_key.dart';
import 'package:fluttertoast/fluttertoast.dart';

// This should be moved somewhere else at some point
//final String URL = "http://ec2-52-91-113-106.compute-1.amazonaws.com:80";
//final String URL = "http://192.168.2.33:8085";
final String URL = "http://ec2-3-86-232-85.compute-1.amazonaws.com:80";
//final String URL = "http://192.168.1.139:80";
// We learned how to create post requests here
//https://stackoverflow.com/questions/50278258/http-post-with-json-on-body-flutter-dart
Future<Map<String, dynamic>> getPost(Map body, String addition) async {
  try {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest r =
    await httpClient.postUrl(Uri.parse(URL + "/" + addition));
    r.headers.set('content-type', 'application/json');
    r.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await r.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    Map<String, dynamic> jsonReply = jsonDecode(reply);
    httpClient.close();
    return jsonReply;
  }
  catch(exc)
  {
    Fluttertoast.showToast(msg: "ERROR: Could not connect to server", gravity: ToastGravity.TOP, backgroundColor: Colors.red);
    return null;
  }
}

Future<List<dynamic>> getPostList(Map body, String addition) async {
  try
  {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest r =
  await httpClient.postUrl(Uri.parse(URL + "/" + addition));
  r.headers.set('content-type', 'application/json');
  r.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await r.close();
  String reply = await response.transform(utf8.decoder).join();
  print(reply);
  List<dynamic> jsonReply = jsonDecode(reply);
  httpClient.close();
  return jsonReply;
}
catch(exc)
  {
    Fluttertoast.showToast(msg: "ERROR: Could not connect to server");
    return null;
  }
}

Future<Image> getPicturePost(Map body, String addition) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest r =
      await httpClient.postUrl(Uri.parse(URL + "/" + addition));
  r.headers.set('content-type', 'application/json');
  r.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await r.close();
  String r2 = (response.toString());
  int count = 0;
  var list = await response.toList();
  int len = list.length;
  for (int i = 0; i < len; i++) {
    count += (list[i].length);
  }
  Uint8List l = new Uint8List(count);
  count = 0;
  for (int i = 0; i < len; i++) {
    for (int j = 0; j < list[i].length; j++) {
      l[count] = list[i][j];
      count++;
    }
  }
  Image img = Image.memory(l);
  //String reply = await response.transform(utf8.decoder).join();
  var x = 2;
  return img;
}

Future<Map<String, dynamic>> uploadImage(Config config) async {
  HttpClient client = new HttpClient();
  http.MultipartRequest request =
      new http.MultipartRequest("POST", Uri.parse(URL + "/uploadProfilePic"));
  Map<String, String> map = {
    "username": config.username,
    "password": passwordHashing(config)
  };
  request.headers.addAll(map);
  http.MultipartFile file =
      await http.MultipartFile.fromPath("image", config.path);
  request.files.add(file);
  var resone = await request.send();

  print(resone);

//  await client(Uri.parse(URL + "/uploadProfilePic"));
//  request.headers.set("content-type", "multipart/form-data");
//  request.headers.add("username", config.username);
//  request.headers.add("password", config.password);
//  Map map =
//  {
//      "image": [ "img", File(config.path).readAsBytesSync()]
//  };
//  //request.add(File(config.path).readAsBytesSync());
// // request.add(utf8.encode(json.encode(map)));
//  request.headers.add("files", File(config.path).readAsBytesSync());
//  HttpClientResponse response = await request.close();
//  String reply = await response.transform(utf8.decoder).join();
//  Map<String, dynamic> jsonReply = jsonDecode(reply);
//   return jsonReply;
}

Future<List<Survey_List>> getSurveys(Config config) async {
  Map map = {'Type': "getSurveys"};
  var _list = [];
  List<Survey_List> surveys = [];
  Map value = await getPost(map, "allSurveys");
  _list.addAll(value["survey"]);

  for (int i = 0; i < _list.length; i++) {
    Survey_List survey_list = Survey_List(
        surveyName: _list[i].toString(),
        surveyDescription: "",
        surveyVersion: "",
        config: null);
    surveys.add(survey_list);
  }
  return surveys;
}

Future<List<Survey_List>> getSurveyHistory(Config con) async {
  String hashString = passwordHashing(con);
  Map map = {"username": con.username, "password": hashString};

  Map surveyMap = await getPost(map, 'userSurveyHistory');
  var _list = [];
  HashSet set = new HashSet();
  for (int i = 0; i < surveyMap["SurveyHistory"].length; i++) {
    _list.addAll(surveyMap["SurveyHistory"][i]);
  }
  set.addAll(_list);
  _list = set.toList();
  List<Survey_List> surveys = [];
  for (int i = 0; i < _list.length; i++) {
    Survey_List survey_list = Survey_List(
        surveyName: _list[i].toString(),
        surveyDescription: "",
        surveyVersion: "",
        config: null);
    surveys.add(survey_list);
  }
  return surveys;
}

void login(Config config, Function(String, Color) functor, Function() update) {

  String hashString = passwordHashing(config);

  Map map = {
    'Type': "login",
    'Username': config.username,
    'Password': hashString
  };

  getPost(map, "login").then((Map value) {
    config.loggedIn = value["Authentication"];
    config.hash = value["Hash"];
    if (config.loggedIn == true) {
      config.loggedIn = true;
      config.actualFirstName = value["first_name"];
      config.actualLastName = value["last_name"];
      config.gender = value["Gender"];
      //config.dob = value["DOB"];
      functor("Login Successful", Colors.blue);
    } else {
      config.loggedIn = false;
      functor("Login not Successful", Colors.red);
    }
  });
}

void getPicture(Config config, Function functor) {
  String hashString = passwordHashing(config);
  Map map = {
    'Type': "ProfilePic",
    "username": config.username,
    "password": hashString
  };

  getPicturePost(map, "ProfilePic").then((Image value) {
    config.img = value;
    config.loggedIn = true;
    functor();
  });
}

void getSurveyByName(Config con, String name, Function functor, ) {
  Map map = {"Type": "getQuestionsForSurvey", "SurveyName": name};

  getPost(map, "surveyQuestions").then((Map value) {
    for (int i = 0; i < value['Questions'].length; i++) {
      value['Questions'][i]['UserAnswer'] = new List<String>();
      value['Questions'][i]['Question'] =  value['Questions'][i]['Question'].replaceAll(new RegExp(r'{CATEGORY}'), value['Questions'][i]['Category']);
      value['Questions'][i]['Question'] =  value['Questions'][i]['Question'].replaceAll(new RegExp(r'{Category}'), value['Questions'][i]['Category']);

    }
    functor(value);
  });
}

void getSurveyQuestionHistory(
    Config con, String surveyName, Function functor) async {
  String hashString = passwordHashing(con);
  Map map = {
    "username":   con.username,
    "password":   hashString,
    "SurveyName": surveyName
};

  getPost(map, 'userSurveyQuestionHistory').then((Map value) {

    functor(value);
  });
}

void signUp(Config config, Function(bool, String, Color) functor) {

  String hashString = passwordHashing(config);

  Map map = {
    "Type": "signup",
    "FirstName": config.actualFirstName,
    "LastName": config.actualLastName,
    "Username": config.username,
    "Password": hashString,
    "Gender": config.gender,
    "BirthDate": DateFormat("yyyy-MM-dd").format(config.dob),
    "Email": config.email,
    "Phone": config.phone,
    "Is_Smoker" : config.smoker,
    "Education" : config.education,
    "Ethnicity" : config.race,
    "Address" : config.address,
    "Income" : config.income
  };

  if (config.is_empty_or_null()) {
    functor(false, "You have blank fields!", Colors.red);
    return;
  }

  if (config.has_spaces()) {
    functor(false, "Spaces are not allowed in fields!", Colors.red);
    return;
  }

  getPost(map, "signup").then((Map value) {
    bool success = value["Account_Creation"];
    if (success) {
      functor(success, "Account Creation Successful!", Colors.black);
    } else {
      functor(success, "Account Creaion Failed ", Colors.red);
    }
  });
}

void outputAnswers(Config config, Map ogMap) {
  String hashString = passwordHashing(config);
  Map map = {
    "Type": "answers",
    "Map": ogMap,
    "Username": config.username,
    "Password": hashString
  };

  getPost(map, "uploadAnswers").then((Map value) {
    print("Submitted");
  });
}

String passwordHashing(Config config){
  String key = EncryptionKey().key;
  String salt = EncryptionKey().salt;
  AesCrypt encrypter = AesCrypt(key, 'cbc', 'pkcs7');
  String encrypted = encrypter.encrypt(config.password, salt);
//  String passwordHash = config.password;
  return encrypted;
}

Future<String> chatBotResponse(Config config, String msg) async{
  String hashString = passwordHashing(config);
  Map map = {
    "username" : config.username,
    "password" : hashString,
    "message"  : msg
  };

  Map surveyMap = await getPost(map, 'chatBotRouter');
  String message = surveyMap["message"];

  return message;
}

Future<String> emotionFromProfilePic(Config config) async {
  String hashString = passwordHashing(config);
  Map map = {
    "username"  : config.username,
    "password"  : hashString,
  };
  Map profileEmotionMap = await getPost(map, 'profilePicAnalysis');
  print(profileEmotionMap);
  if(profileEmotionMap["emotion"] != null) {
    return profileEmotionMap["emotion"];
  }
  else {
    return "not perceivable";
  }
}
void sendGPSLocation(Config config) {
  String hashString = passwordHashing(config);
  Map map = {
    "Map": config.locData,
    "Username": config.username,
    "Password": hashString,
    "Country" : config.locData["Country"],
    "State" : config.locData["State"],
    "City" : config.locData["City"],
    "Longitude" : config.locData["Longitude"],
    "Latitude" : config.locData["Latitude"]
  };

  getPost(map, "sendGPSLocation").then((Map value) {
    print(value);
  });
}

Future<List<Coordinates>> getGPSLocations(Config config) async {
  Map map = {'Type': "getGPS"};
  var _list = [];
  List<Coordinates> allCords = [];
  List allLocations = await getPostList(map, 'allGPS');
  for (int i = 0; i < allLocations.length; i++) {
    Coordinates cords = new Coordinates(
        double.parse(allLocations[i]['Latitude']),
        double.parse(allLocations[i]['Longitude']));
    allCords.add(cords);
  }
  return allCords;
}
