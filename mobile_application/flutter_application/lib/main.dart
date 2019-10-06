import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      title: '',
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final Config config = Config("", "", "", "", false, "");

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    widget.config.loginState = "Try to login";

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
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage(
          config: widget.config,
        );
      }));
    }

    void _createAccount() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return CreatePage(
          outerConfig: widget.config,
        );
      }));
    }

    Widget buttonOptions = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getPaddedButton("Login", _pushSaved),
          getPaddedButton("Create Account", _createAccount),
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
        body: Column(
          children: [
            titleSection,
            Divider(),
            Expanded(child: Center(child: buttonOptions)),
          ],
        ),
      ),
    );
  }
}
