import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application/profile_pic.dart';
import 'package:flutter_application/survey_list.dart';
import 'login_page.dart';
import 'Config.dart';
import 'primary_widgets.dart';
import 'create_page.dart';

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
        '/create' : (context) => CreatePage(),
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
      Navigator.of(context)
          .push(MaterialPageRoute(settings: RouteSettings(name: "/login"), builder: (BuildContext context) {
        return LoginPage(
          config: widget.config,
        );
      }));
    }


    void _createAccount() {
      Navigator.of(context)
          .push(MaterialPageRoute(settings: RouteSettings(name: "/create"), builder: (BuildContext context) {
        return CreatePage(
          outerConfig: widget.config,
        );
      }));
    }


    void _changePicture() {
      Navigator.of(context)
          .push(MaterialPageRoute(settings: RouteSettings(name: "/profilepic"), builder: (BuildContext context) {
        return ProfilePic(
          config: widget.config,
        );
      }));
    }

    
    void _takeSurvey() {
      Navigator.of(context)
          .push(MaterialPageRoute(settings: RouteSettings(name: "/survey"), builder: (BuildContext context) {
        return Survey_List(
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
              getPaddedButton("Take Survey", _takeSurvey),
              getPaddedButton("Have Conversation", () {}),
            ],
          ),
        );
      } else {
        return Container(
            width:  400,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getPaddedButton("Take Survey", _takeSurvey),
              getPaddedButton("Have Conversation", () {}),
              getPaddedButton("View Metrics", () {}),
              getPaddedButton("Change Profile Picture", _changePicture),
              getPaddedButton("Logout", () {
                this.widget.config.clear();
                update();
              }),
            ],
          ),
        );
      }
    }

    Widget getImage() {
      double width = 100;
      if (widget.config.img != null) {
        return Image(
          image: widget.config.img.image,
          width: width,
        );
      } else {
        return Text("");
      }
    }

    return MaterialApp(
      title: 'Home',
      home: Scaffold(
        appBar: AppBar(
            title: Row(
          children: <Widget>[
            Text('Pyschological Survey App'),
            Padding(
              padding: EdgeInsets.only(left: 35),
              child: getImage(),
            ),
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
