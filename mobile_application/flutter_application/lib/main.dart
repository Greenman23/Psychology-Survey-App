import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'login_page.dart';

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
      title: '',
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
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

    Widget getPaddedButton(String buttonText, Function functor) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: ButtonTheme(
          minWidth: 400,
          height: 50,
          child: RaisedButton(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 20),
            ),
            splashColor: Colors.red,
            color: Colors.cyan,
            onPressed: () {
              functor();
            },
          ),
        ),
      );
    }

    void _pushSaved() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage(
          text: "Eric bon Eric",
        );
      }));
    }

    Widget buttonOptions = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getPaddedButton("Login", _pushSaved),
          getPaddedButton("Create Account", () {}),
          getPaddedButton("Take Survey", () {}),
          getPaddedButton("View Metrics", () {}),
          getPaddedButton("Logout", () {}),
        ],
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pyschological Survey App'),
        ),
        body: Column(children: [
          titleSection,
          Divider(),
          Expanded(child: Center(child: buttonOptions)),
        ],
        ),
      ),
    );
  }
}
