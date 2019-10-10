import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'Config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'primary_widgets.dart';

class Survey_List extends StatefulWidget {
  Config config;
  Survey_List({
    Key key,
    @required this.config,
  }) : super (key: key);
  @override
  _SurveyListState createState() => _SurveyListState();

}
class _SurveyListState extends State<Survey_List> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surveys"),
      ),
      body: ListView(
        children: <Widget>[
          getPaddedButton("Survey 1", (){}),
          getPaddedButton("Survey 2", (){}),
          getPaddedButton("Survey 3", (){}),
          getPaddedButton("Survey 4", (){}),
        ],
      ),
    );
  }
}
