import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_application/config.dart';
import 'Http.dart';
import 'primary_widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'profile_pic.dart';
import 'package:intl/intl.dart';

class CreatePage extends StatefulWidget {
  Config outerConfig;

  CreatePage({Key key, @required this.outerConfig}) : super(key: key);

  @override
  CreatePageState createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  TextEditingController firstName, lastName, userName, password, passwordVerify,
  phone, myEmail, myAddress, income;
  String createAccountResult;
  Color createAccountColor;
  Color passwordMatchColor;
  String passwordsMatch;
  String gender;
  String email;
  String education;
  String race;
  String smoker;
  int phoneNumber;
  Config innerConfig;

  @override
  void initState() {
    firstName = new TextEditingController(text: "");
    lastName = new TextEditingController(text: "");
    userName = new TextEditingController(text: "");
    password = new TextEditingController(text: "");
    passwordVerify = new TextEditingController(text: "");
    income = new TextEditingController(text: "\$");
    createAccountColor = Colors.black;
    createAccountResult = "";
    gender = "Male";
    race = "Prefer not to say";
    smoker = "No";
    education="Bachelors";
    passwordMatchColor = Colors.black;
    innerConfig = new Config("","","","","", "", "", "", false, false);
    innerConfig.dob = DateTime.now();
    innerConfig.gender = "Male";
    innerConfig.race = "Prefer not to say";
    innerConfig.smoker = "No";
    innerConfig.education = "Bachelors";

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

    Widget dropDownGender() {
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

    Widget dropDownEducation() {
      return Padding(
        padding: EdgeInsets.all(30),
        child: DropdownButton<String>(
          value: innerConfig.education,
          iconSize: 24,
          icon: Icon(Icons.arrow_downward),
          items: <String>['Some High School','High School','Some College',
            'Associates','Bachelors','Masters','PHD']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              innerConfig.education = newValue;
            });
          },
        ),
      );
    }


    Widget dropDownSmoker() {
      return Padding(
        padding: EdgeInsets.all(30),
        child: DropdownButton<String>(
          value: innerConfig.smoker,
          iconSize: 24,
          icon: Icon(Icons.arrow_downward),
          items: <String>['No', 'Yes']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              innerConfig.smoker = newValue;
            });
          },
        ),
      );
    }

    Widget dropDownRace() {
      return Padding(
        padding: EdgeInsets.all(30),
        child: DropdownButton<String>(
          value: innerConfig.race,
          iconSize: 24,
          icon: Icon(Icons.arrow_downward),
          items: <String>['White', 'Black', 'Hispanic', 'Asian',
            'Native American', 'Pacific Islander', 'Other',
            'Prefer not to say']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              innerConfig.race = newValue;
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
        if (success) {
          widget.outerConfig.username = innerConfig.username;
          widget.outerConfig.password = innerConfig.password;
          widget.outerConfig.loggedIn = true;
          widget.outerConfig.storeGlobalConfig().then((_) {
            Navigator.of(context).push(MaterialPageRoute(
                settings: RouteSettings(name: "/profilepicture"),
                builder: (BuildContext context) {
                  return ProfilePic(config: widget.outerConfig);
                }));
            update();
          });
        }
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
          getText("Email"),
          getTextFormField(myEmail, "Your email", (String tex) {
            innerConfig.email = tex;
          }),
          getText("Address"),
          getTextFormField(myAddress, "Your Address", (String tex) {
            innerConfig.address = tex;
          }),
          getText("Phone Number"),
          getPhoneFormField(phone, "##########", (String num) {
            innerConfig.phone = num;
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
          getText("Gender"),
          dropDownGender(),
          getText("Race"),
          dropDownRace(),
          getText("Education"),
          dropDownEducation(),
          getText("Smoker"),
          dropDownSmoker(),
          getText("Income"),
          getMoneyFormField(income, "Approximate income to the nearest dollar", (String tex){

            if(tex.length == 0)
              {
                tex = "\$";
              }
            if(tex.contains(".")) {
              tex = tex.replaceAll(".", "");
            }
            if(income.text[0] != '\$')
              {
                tex = income.text.replaceAll("\$", "");
                tex = "\$" + tex;
              }
            income.text = tex;
            innerConfig.income = tex;
          }),
          getText(DateFormat("MM/dd/yyyy").format(innerConfig.dob)),
          getPaddedButton(
            "Set Date of birth",
            () {
              getDatePicker();
              update();
            },
          ),
          getPaddedButton("Create ", () {
            if (password.text != passwordVerify.text) {
              createAccountResult = "Passwords do not match";
              createAccountColor = Colors.red;
              update();
            } else {
              _signupHttp();
            }
          }),
          getText(createAccountResult, color: createAccountColor),
        ],
      ),
    );
  }
}
