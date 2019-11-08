import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_application/config.dart';
import 'package:flutter_application/Http.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'primary_widgets.dart';
import 'package:geocoder/geocoder.dart';

class LoginPage extends StatefulWidget {
  Config config;

  LoginPage({
    Key key,
    @required this.config,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController myController;

  TextEditingController passwordController;
  Color outComeColor;
  String loginState;
  bool provideLocation;
  Location location = new Location();
  Map userLocationMap;
  String stringAddress = "";
  LocationData currentLocation;
  String error;

  @override
  void initState() {
    super.initState();
    initializeLocation();
    myController = new TextEditingController(text: "");
    passwordController = new TextEditingController(text: "");
    myController.text = widget.config.username;
    passwordController.text = widget.config.password;
    outComeColor = Colors.black;
    loginState = "Try to login";
  }

  void setupAddresses(Coordinates coord) async {
    Geocoder.local.findAddressesFromCoordinates(coord).then((err)
    {
      if(userLocationMap == null) {
        userLocationMap = {
          'City'    : err[0].locality,
          'County'  : err[0].subAdminArea,
          'State'   : err[0].adminArea,
          'Country' : err[0].countryName,
        };

        stringAddress = err[0].locality+", "+err[0].adminArea+", "+
            err[0].countryName;

        setState(() {
        });
      }
    });
  }

  initializeLocation() async {

    LocationData tempLoc;

    try {
      bool locationStatus = await location.serviceEnabled();
      print("LocationStatus: " + locationStatus.toString());
      if (locationStatus) {
        provideLocation = await location.requestPermission();
        print("Provide Location Inside Location Status: " +
            provideLocation.toString());
        if (provideLocation) {
          tempLoc = await location.getLocation();

          final cords = new Coordinates(tempLoc.latitude, tempLoc.longitude);

          setupAddresses(cords);

          if (mounted) {
            setState(() {
              currentLocation = tempLoc;
            });
          }
        } else {
          bool locationStatus = await location.serviceEnabled();
          if (locationStatus) {
            initializeLocation();
          }
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      currentLocation = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ListView(
        children: <Widget>[
          getTextFormField(myController, "Username", (String tex) {
            widget.config.username = tex;
          }),
          getTextFormField(passwordController, "Password", (String tex) {
            widget.config.password = tex;
          }, isPassword: true),
          getPaddedButton("Login", _loginHTTP),
          getText(loginState, color: outComeColor, fontSize: 16),
        ],
      ),
    );
  }

  void updateText(String text, Color color) {
    loginState = text;
    outComeColor = color;
    if (loginState == "Login Successful") {
      updateLocation();
      widget.config.storeGlobalConfig().then((e) {
          Navigator.popUntil(this.context, ModalRoute.withName("/"));
          setState(() {});
      });
    }
  }

  void updateLocation(){
    widget.config.locData = userLocationMap;
    print(userLocationMap);
  }

  void update()
  {
    setState(() {

    });
  }

  void _loginHTTP() {
    login(widget.config, updateText, update);
  }
}
