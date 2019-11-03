import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application/gps_location.dart';
import 'package:flutter_application/profile_pic.dart';
import 'package:flutter_application/survey_list.dart';
import 'package:path/path.dart' as prefix0;
import 'package:path_provider/path_provider.dart';
import 'login_page.dart';
import 'package:flutter_application/config.dart';
import 'primary_widgets.dart';
import 'create_page.dart';
import 'package:path/path.dart';
import 'package:flutter_application/Http.dart';

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
  final Config config = Config("", "", "", "", false, false);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    int x = 2;
    widget.config.getGlobalConfig(update);
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

    void _takeSurvey() {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: "/survey"),
          builder: (BuildContext context) {
            return SurveyListStateful(
              config: widget.config,
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
              getPaddedButton("Have Conversation", () {}),
              getPaddedButton("View Metrics", () {}),
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

    Text getUsername()
    {
      if(widget.config.username != null)
        {
          if(widget.config.username != "")
            {
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
          children: <Widget>[
            getUsername(),
            getImage()
          ],
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
