import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application/Http.dart';
import 'package:flutter_application/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'primary_widgets.dart';
import 'TakeSurvey.dart';

// TODO : Make the surveys their own buttons instead of just listing them.

class Survey_List {
  final Config config;

  String surveyName;
  String surveyDescription;
  String surveyVersion;

  Survey_List(
      {this.surveyName,
      this.surveyDescription,
      this.surveyVersion,
      Key key,
      @required this.config});
}

class SurveyListStateful extends StatefulWidget {
  Config config;
  Function getFutureList;
  Function getInformation;
  Function(Map map) startTaskWithFuture;

  SurveyListStateful(
      {this.config, this.getFutureList, this.getInformation, this.startTaskWithFuture});

  @override
  State createState() {
    return SurveyListState(config: config);
  }
}

class SurveyListState extends State<SurveyListStateful> {
  Config config;

  SurveyListState({this.config});

  Future fut;
  BuildContext context;



  @override
  void initState() {
    fut = widget.getFutureList(widget.config);
  }

  Widget getView() {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Surveys"),
      ),
      body: new Container(
        child: new FutureBuilder(
          future: fut,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                      child:
                          getPaddedButton(snapshot.data[index].surveyName, () {
                    widget.getInformation(
                        widget.config, snapshot.data[index].surveyName, widget.startTaskWithFuture);
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
    this.context = context;
    return getView();
  }
}
