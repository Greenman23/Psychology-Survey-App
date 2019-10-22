import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'primary_widgets.dart';
import 'dart:math';

class Results extends StatelessWidget {
  List<String> diagnosis = new List<String>();

  Widget build(BuildContext context) {
    diagnosis.add("Bipolar");
    diagnosis.add("Depression");
    diagnosis.add("Borderline personality disorder");
    diagnosis.add("Schizophrenia");
    diagnosis.add("Brain ulcers");

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
            child: Column(
          children: <Widget>[
            getText("You have signs of " +
                diagnosis[Random().nextInt(diagnosis.length - 1)]),
            getPaddedButton("Finish", () {
              Navigator.popUntil(context, ModalRoute.withName("/"));
            })
          ],
        )),
      ),
    );
  }
}
