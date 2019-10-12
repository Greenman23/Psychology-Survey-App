import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application/Http.dart';
import 'Config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Survey_List extends StatefulWidget {
  String surveyName;
  String surveyDescription;
  String surveyVersion;

  Survey_List({
    this.surveyName,
    this.surveyDescription,
    this.surveyVersion,
    Key key,
  }) : super (key: key);
  @override
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends State<Survey_List> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Surveys"),
      ),
      body: Container(
        child: FutureBuilder <List<Survey_List>>(
          future: getSurveys(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            if (snapshot.data == null) {
              return Container(
                  child: Center(
                      child: new Text("Loading...")
                  )
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].surveyName)
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
