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
        }
      else
        {
          functor("Login not Successful", Colors.red);
        }

    });
}
