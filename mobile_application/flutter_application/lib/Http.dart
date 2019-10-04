import 'dart:convert';
import 'dart:io';
import 'Config.dart';
import 'package:flutter/cupertino.dart';


final String URL = "http://192.168.2.33:80";


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

void login(Config config, Function(String) functor)
{
    Map  map = {
      'Type': "login",
      'Username' : config.username,
      'Password' : config.password
    };

    getPost(map).then((Map value)  {
      config.loggedIn = value["authentication"];
      config.hash = value["hash"];
      print("We got it bois");
      if(config.loggedIn == true)
        {
          functor("We did it bois");
        }
      else
        {
          functor("We did not do it my bois");
        }

    });
}
