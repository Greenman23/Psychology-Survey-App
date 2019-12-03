import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'primary_widgets.dart';
import 'results.dart';
import 'package:flutter_application/Http.dart';
import 'package:flutter_application/config.dart';

class Survey_History_Overview extends StatelessWidget {
  Map survey;
  Config config;

  Survey_History_Overview({@required this.config, @required this.survey});

  Widget build(BuildContext buildContext) {
    //List<Map> actualSurvey = survey['Questions'];
    int current_index = 0;
    List keys = survey.keys.toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Survey History Overview"),
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    int temp_index = 0;
                    bool firstItem = true;
                    var stuff = survey[keys[index]];
                    List<Map> items = new List<Map>.from(survey[keys[index]]);
                    items.insert(0, {'date': keys[index]});
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
                            (Map answer) {
                              if (firstItem) {
                                firstItem = false;
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (current_index).toString() +
                                            ": " +
                                            answer['date'].toString().substring(
                                                0,
                                                answer['date']
                                                    .toString()
                                                    .indexOf("GMT")),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ]);
                              } else if (answer['Answer'] != "") {
                                temp_index += 1;
                                return getQuestionAnswer(answer['Question'], answer['Answer']);
                              } else {
                                temp_index += 1;
                                return Container();
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
            ],
          )
        ]));
  }
}
