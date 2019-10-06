import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'Config.dart';
import 'Http.dart';
import 'primary_widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreatePage extends StatefulWidget {
  Config outerConfig;
  CreatePage({Key key, @required this.outerConfig}) : super(key: key);

  @override
  CreatePageState createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  TextEditingController firstName, lastName, userName, password, passwordVerify;
  String createAccountResult;
  Color createAccountColor;
  Color passwordMatchColor;
  String passwordsMatch;
  String gender;
  Config innerConfig;
  @override
  void initState() {
    firstName = new TextEditingController(text: "");
    lastName = new TextEditingController(text: "");
    userName = new TextEditingController(text: "");
    password = new TextEditingController(text: "");
    passwordVerify = new TextEditingController(text: "");
    createAccountColor = Colors.black;
    createAccountResult = "";
    gender = "Male";
    passwordMatchColor = Colors.black;
    innerConfig = new Config("", "", "", "", false, "");
    innerConfig.dob = DateTime.now();
    innerConfig.gender = "Male";
    passwordsMatch = "";

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    passwordsMatch = password.text == passwordVerify.text
        ? "Passwords match"
        : "Passwords do not match";
    passwordMatchColor =
        password.text == passwordVerify.text ? Colors.blue : Colors.red;

    void update() {
      setState(() {});
    }

    Widget dropDown() {
      return Padding(
        padding: EdgeInsets.all(30),
        child: DropdownButton<String>(
          value: innerConfig.gender,
          iconSize: 24,
          icon: Icon(Icons.arrow_downward),
          items: <String>['Male', 'Female']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              innerConfig.gender = newValue;
            });
          },
        ),
      );
    }

    Widget getDatePicker() {
      DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(),
        currentTime: innerConfig.dob,
        locale: LocaleType.en,
        onChanged: (DateTime date) {
          innerConfig.dob = date;
          update();
        },
      );
    }

    void _signupHttp() {
      signUp(innerConfig, (bool success, String str, Color col) {
        createAccountResult = str;
        createAccountColor = col;
        if(success)
          {
            widget.outerConfig.username = innerConfig.username;
            widget.outerConfig.password = innerConfig.password;
          }
        update();
      });

    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Page"),
      ),
      body: ListView(
        children: <Widget>[
          getText("First Name"),
          getTextFormField(firstName, "Your first name", (String tex) {
            innerConfig.actualFirstName = tex;
          }),
          getText("Last Name"),
          getTextFormField(lastName, "Your last name", (String tex) {
            innerConfig.actualLastName = tex;
          }),
          getText("User Name"),
          getTextFormField(userName, "Your user name", (String tex) {
            innerConfig.username = tex;
          }),
          getText(passwordsMatch, color: passwordMatchColor),
          getText("Password"),
          getTextFormField(password, "Your password", (String tex) {
            innerConfig.password = tex;
            update();
          }, isPassword: true),
          getText("Verify your password"),
          getTextFormField(passwordVerify, "Verify your password",
              (String tex) {
            update();
          }, isPassword: true),
          dropDown(),
          getText(innerConfig.dob.month.toString() +
              "/" +
              innerConfig.dob.day.toString() +
              "/" +
              innerConfig.dob.year.toString()),
          getPaddedButton(
            "Set Date of birth",
            () {
              getDatePicker();
              update();
            },
          ),
          getPaddedButton("Create ", () {
            _signupHttp();
          }),
          getText(createAccountResult, color:createAccountColor),
        ],
      ),
    );
  }
}