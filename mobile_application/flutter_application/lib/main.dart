import 'dart:io';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application/chatbot.dart';
import 'package:flutter_application/gps_location.dart';
import 'package:flutter_application/profile_pic.dart';
import 'package:flutter_application/survey_list.dart';
import 'package:path/path.dart' as prefix0;
import 'package:path_provider/path_provider.dart';
import 'TakeSurvey.dart';
import 'login_page.dart';
import 'package:flutter_application/config.dart';
import 'primary_widgets.dart';
import 'create_page.dart';
import 'package:path/path.dart';
import 'package:flutter_application/Http.dart';
import 'package:flutter_application/survey_history_overview.dart';
import 'package:geocoder/geocoder.dart';

// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/create': (context) => CreatePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final Config config = Config("", "", "", "", "" "", "", "", "", false, false);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool provideLocation;
  Location location;
  Map userLocationMap;
  String stringAddress;
  LocationData currentLocation;
  String error;

  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    int x = 2;
    location = new Location();
    stringAddress = "";
    widget.config.getGlobalConfig((){
      initializeLocation().then((val){
        updateLocation();
        update();
      });
    });
  }

  void updateLocation() {
    widget.config.locData = userLocationMap;
    sendGPSLocation(widget.config);
    print(userLocationMap);
  }

  void setupAddresses(Coordinates coord) async {
    Geocoder.local.findAddressesFromCoordinates(coord).then((err) {
      if (userLocationMap == null) {
        userLocationMap = {
          'City': err[0].locality,
          'State': err[0].adminArea,
          'Country': err[0].countryName,
        };

        stringAddress = err[0].locality +
            ", " +
            err[0].adminArea +
            ", " +
            err[0].countryName;
        updateLocation();
        setState(() {});
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
    Widget titleSection = Container(
      child: Row(children: [
        Expanded(
          child: Text(
            "Pychological Survey App",
            textScaleFactor: 3,
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );

    ButtonTheme mainButtonTheme = ButtonTheme(
      minWidth: 400,
      height: 50,
    );

    void _pushSaved() {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/login"),
          builder: (BuildContext context) {
            return LoginPage(
              config: widget.config,
            );
          }));
    }

    void _createAccount() {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/create"),
          builder: (BuildContext context) {
            return CreatePage(
              outerConfig: widget.config,
            );
          }));
    }

    void _changePicture() {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/profilepic"),
          builder: (BuildContext context) {
            return ProfilePic(
              config: widget.config,
              isCreator: false,
            );
          }));
    }

    void _changeLocation() {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/gpslocation"),
          builder: (BuildContext context) {
            return GPSLocation(
              config: widget.config,
            );
          }));
    }

    void startSurvey(Map map) {
      List<String> disabledValues = new List<String>();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return Survey_Question(
          map: map,
          index: 0,
          disabledValues: disabledValues,
          config: widget.config,
        );
      }));
    }

    void startHistory(Map map) {
      for (int i = 0; i < 2; i++) {
        int x = 2;
      }
      Map refinedMap = map['surveys'][0];
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/history_overview"),
          builder: (BuildContext context) {
            return Survey_History_Overview(
                config: widget.config, survey: refinedMap);
          }));
    }

    void _viewHistory() {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/survey"),
          builder: (BuildContext context) {
            return SurveyListStateful(
              config: widget.config,
              getFutureList: getSurveyHistory,
              getInformation: getSurveyQuestionHistory,
              startTaskWithFuture: startHistory,
            );
          }));
    }

    void _takeSurvey() {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/survey"),
          builder: (BuildContext context) {
            return SurveyListStateful(
              config: widget.config,
              getFutureList: getSurveys,
              getInformation: getSurveyByName,
              startTaskWithFuture: startSurvey,
            );
          }));
    }

    void _haveConversation() {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/chatbot"),
          builder: (BuildContext context) {
            return ChatBot(
              con: widget.config,
            );
          }));
    }

    void update() {
      setState(() {});
    }

    Widget getMenu() {
      if (!widget.config.loggedIn) {
        return Container(
          width: 400,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getPaddedButton("Login", _pushSaved),
              getPaddedButton("Create Account", _createAccount),
              getPaddedButton("Have Conversation", () {}),
            ],
          ),
        );
      } else {
        return Container(
          width: 400,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getPaddedButton("Take Survey", _takeSurvey),
              getPaddedButton("Have Conversation", _haveConversation),
              getPaddedButton("View History", _viewHistory),
              getPaddedButton("Change Profile Picture", _changePicture),
              getPaddedButton("Change Location Data", _changeLocation),
              getPaddedButton("Logout", () {
                this.widget.config.clear();
                widget.config.storeGlobalConfig().then((a) {
                  update();
                });
              }),
            ],
          ),
        );
      }
    }

    Widget getImage() {
      if (widget.config.loggedIn) {
        double width = 100;
        if (widget.config.img != null) {
          return Image(
            image: widget.config.img.image,
            width: width,
            height: 100,
          );
        } else {
          getPicture(widget.config, update);
        }
      }
      return Text("");
    }

    Text getUsername() {
      if (widget.config.username != null) {
        if (widget.config.username != "") {
          return Text(widget.config.username);
        }
      }
      return Text("Welcome to the App!");
    }

    return MaterialApp(
      title: 'Home',
      home: Scaffold(
        appBar: AppBar(
            title: Row(
          children: <Widget>[getUsername(), getImage()],
        )),
        body: Column(
          children: [
            Divider(),
            Expanded(child: getMenu()),
          ],
        ),
      ),
    );
  }
}
