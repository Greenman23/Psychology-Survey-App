import 'dart:convert';
import 'dart:io';
import 'Config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This should be moved somewhere else at some point
final String URL = "http://192.168.2.33:80";

// We learned how to create post requests here
//https://stackoverflow.com/questions/50278258/http-post-with-json-on-body-flutter-dart
Future<Map<String, dynamic>> getPost(Map body) async
{
  HttpClient httpClient = new HttpClient();
  HttpClientRequest r = await httpClient.postUrl(Uri.parse(URL));
  r.headers.set('content-type', 'application/json');
  r.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await r.close();
  String reply = await response.transform(utf8.decoder).join();
  print(reply);
  Map<String, dynamic> jsonReply = jsonDecode(reply);
  httpClient.close();
  return jsonReply;
}

void login(Config config, Function(String, Color) functor)
{
    Map  map = {
      'Type': "login",
      'Username' : config.username,
      'Password' : config.password
    };

    getPost(map).then((Map value)  {
      config.loggedIn = value["Authentication"];
      config.hash = value["Hash"];
      print("We got it bois");
      if(config.loggedIn == true)
        {
          functor("Login Successful", Colors.blue);
          config.loggedIn = true;
        }
      else
        {
          functor("Login not Successful", Colors.red);
          config.loggedIn = false;
        }

    });
}

void signUp(Config config, Function(bool, String, Color) functor)
{
  Map map = {
    "Type" : "signup",
    "FirstName" : config.actualFirstName,
    "LastName" : config.actualLastName,
    "Username" : config.username,
    "Password" : config.password,
    "Gender" : config.gender,
    "BirthDate" : "1997-01-12"
  };

  if(config.is_empty_or_null())
    {
      functor(false, "You have blank fields!", Colors.red);
      return;
    }

  if(config.has_spaces())
    {
      functor(false, "Spaces are not allowed in fields!", Colors.red);
      return;
    }

  getPost(map).then((Map value){
    bool success = value["Account_Creation"];
    if(success)
      {
        functor(success, "Account Creation Successful!", Colors.black);
      }
    else
      {
        functor(success, "Account Creaion Failed " , Colors.red);
      }
  });


}

