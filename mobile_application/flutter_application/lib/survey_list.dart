import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application/Http.dart';
import 'Config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'primary_widgets.dart';
import 'TakeSurvey.dart';

// TODO : Make the surveys their own buttons instead of just listing them.

class Survey_List extends StatefulWidget {
  final Config config;

  String surveyName;
  String surveyDescription;
  String surveyVersion;

  Survey_List(
      {this.surveyName,
      this.surveyDescription,
      this.surveyVersion,
      Key key,
      @required this.config})
      : super(key: key);

  @override
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends State<Survey_List> {
  void startSurvey(Map map)
  {
    List<String> disabledValues = new List<String>();
    Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
          return Survey_Question(map: map,  index: 0, disabledValues: disabledValues);
        }));
  }

  Widget getView() {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Surveys"),
      ),
      body: new Container(
        child: new FutureBuilder(
          future: getSurveys(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                      child:
                          getPaddedButton(snapshot.data[index].surveyName, () {
                    getSurveyByName(
                        snapshot.data[index].surveyName, startSurvey);
                  }));
                },
              );
            } else {
              return new Container(
                  child: new Center(child: new Text("Loading...")));
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getView();
  }
}
