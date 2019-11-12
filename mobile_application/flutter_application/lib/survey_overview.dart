import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'primary_widgets.dart';
import 'reults.dart';
import 'package:flutter_application/Http.dart';
import 'package:flutter_application/config.dart';
class Survey_Overview extends StatelessWidget {
  Map survey;
  Config config;
  Survey_Overview({@required this.config, @required this.survey});

  Widget build(BuildContext buildContext) {
    //List<Map> actualSurvey = survey['Questions'];
    int current_index = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text("Survey Overview"),
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: survey['Questions'].length,
                  itemBuilder: (BuildContext context, int index) {
                    bool firstItem = true;
                    List<String> items = new List<String>.from(
                        survey['Questions'][index]['UserAnswer']);
                    items.insert(0, survey['Questions'][index]['Question']);
                    if (items.length == 1) {
                      return Container();
                    }
                    current_index += 1;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items.map<Widget>(
                            (String answer) {
                              if (firstItem) {
                                firstItem = false;
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (current_index).toString() +
                                            ": " +
                                            answer,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ]);
                              } else {
                                return Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(answer));
                              }
                            },
                          ).toList()),
                    );
                  })),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getPaddedButton("Go back", () {
                Navigator.pop(buildContext);
              }),
              getPaddedButton("See results", () {
                outputAnswers(config, survey);
                Navigator.of(buildContext).push(MaterialPageRoute(
                                builder: (BuildContext context) {return Results();
                    }));
              })
            ],
          )
        ]));
  }
}
