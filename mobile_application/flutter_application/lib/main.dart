import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      height:  50,
    );

    Widget buttonOptions = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            bottom: 20
          ),
       child: ButtonTheme(
          minWidth: 400,
          height:  50,
        child: RaisedButton(

          child: Text('Login',
           style: TextStyle(fontSize: 20),
          ),
          splashColor: Colors.red,
          color: Colors.cyan,
          onPressed: (){
          },
        ),
        ),
        ),
        RaisedButton(
          child: Text('Create Account',
          style: TextStyle(fontSize: 20),
    ),
          splashColor: Colors.red,
          color: Colors.cyan,
          onPressed: (){

          },
        ),
      ],
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pyschological Survey App'),
        ),
        body: Column(
          children: [titleSection, Divider(),Center( child:buttonOptions)],
        ),
      ),
    );
  }
}

