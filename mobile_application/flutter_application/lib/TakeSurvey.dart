import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'primary_widgets.dart';
import 'survey_overview.dart';
import 'package:flutter_application/config.dart';

class Survey_Question extends StatefulWidget {
  Map map;
  int index;
  String surveyName;
  List<String> disabledValues;
  Config config;

  Survey_Question(
      {Key key,
      @required this.map,
      @required this.index,
      @required this.disabledValues,
      @required this.config})
      : super(key: key) {
    Map concopy = new Map();
    concopy['Questions'] = [];
    for (int i = 0; i < this.map['Questions'].length; i++) {
      if (this.map['Questions'][i]['ChatorSurv'] != "C") {
        concopy['Questions'].add(this.map['Questions'][i]);
      }
    }
    this.map = concopy;
  }

  @override
  Survey_Question_State createState() => Survey_Question_State();
}

class Survey_Question_State extends State<Survey_Question> {
  @override
  String radioGroupValue;
  TextEditingController controller;

  void initState() {
    Map question = widget.map['Questions'][widget.index];
    question['Answers'].remove("-1");
    question['Type'] = "S";
    if (question['UserAnswer'].length != 0) {
      controller = new TextEditingController(text: question['UserAnswer'][0]);
      radioGroupValue = question['UserAnswer'][0];
    } else {
      // Keep the radio group value uninitialized
      controller = new TextEditingController(text: "");
    }
  }

  Widget getWidgetByQuestion() {
    Map question = widget.map['Questions'][widget.index];
    switch (question['QuestionType']) {
      case 'Disabler':
        return getDisabler(question);
        break;

      case 'MultipleChoiceRadio':
        return getMultipleChoiceRadio(question);
        break;

      case 'MultipleChoice':
        return getMultipleChoice(question);
        break;

      case 'FillInTheBlank':
        return getFillInTheBlank(question);
        break;

      default:
        return getScaryWidget(question);
    }
  }

  Widget getDisabler(Map question) {
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            Container(
              child: Radio<String>(
                value: question['Answers'][index],
                groupValue: radioGroupValue,
                onChanged: (String value) {
                  setState(() {
                    if (question['UserAnswer'].length == 0) {
                      question['UserAnswer'].add(value);
                    } else {
                      question['UserAnswer'][0] = value;
                    }
                    radioGroupValue = value;
                    // Todo Find a better way to detect if you are disabling or not
                    if (value == 'No') {
                      widget.disabledValues.add(question['Category']);
                    } else if (value == 'Yes') {
                      widget.disabledValues
                          .removeWhere((item) => item == question['Category']);
                    }
                  });
                },
              ),
            ),
            Container(
              child: Text(question['Answers'][index]),
              width: 300,
            ),
          ],
        );
      },
      itemCount: question['Answers'].length,
    );
  }

  Widget getMultipleChoiceRadio(Map question) {
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            Container(
              child: Radio<String>(
                value: question['Answers'][index],
                groupValue: radioGroupValue,
                onChanged: (String value) {
                  setState(() {
                    if (question['UserAnswer'].length == 0) {
                      question['UserAnswer'].add(value);
                    } else {
                      question['UserAnswer'][0] = value;
                    }
                    radioGroupValue = value;
                  });
                },
              ),
            ),
            Container(
              child: Text(question['Answers'][index]),
              width: 300,
            ),
          ],
        );
      },
      itemCount: question['Answers'].length,
    );
  }

  Widget getMultipleChoice(Map question) {
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            Container(
              child: Checkbox(
                value:
                    question['UserAnswer'].contains(question['Answers'][index]),
                onChanged: (bool value) {
                  setState(() {
                    if (value) {
                      question['UserAnswer'].add(question['Answers'][index]);
                    } else {
                      question['UserAnswer'].remove(question['Answers'][index]);
                    }
                  });
                },
              ),
            ),
            Container(
              child: Text(question['Answers'][index]),
              width: 300,
            ),
          ],
        );
      },
      itemCount: question['Answers'].length,
    );
  }

  Widget getFillInTheBlank(Map question) {
    return new TextFormField(
      controller: controller,
      minLines: 6,
      maxLines: 20,
      maxLength: 450,
      onChanged: (String tex) {
        if (question['UserAnswer'].length == 0) {
          question['UserAnswer'].add(tex);
        } else {
          question['UserAnswer'][0] = tex;
        }
      },
    );
  }

  Widget getScaryWidget(Map question) {
    return Text("Hi this is broken fix the databse please");
  }

  Survey_Question navigateToNext() {
    bool widgetSatisfied = false;
    int newIndex = widget.index + 1;
    while (!widgetSatisfied && newIndex < widget.map['Questions'].length) {
      if (widget.disabledValues
          .contains(widget.map['Questions'][newIndex]['Category'])) {
        newIndex += 1;
      } else {
        widgetSatisfied = true;
      }
    }

    if (widgetSatisfied) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return Survey_Question(
            map: widget.map,
            config: widget.config,
            index: newIndex,
            disabledValues: widget.disabledValues);
      }));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return Survey_Overview(
          config: widget.config,
          survey: widget.map,
        );
      }));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onHorizontalDragUpdate: (DragUpdateDetails details)
            {
                if (details.delta.dx > 15) {
                  Navigator.pop(context);
                }
                else if(details.delta.dx < -15){
                  navigateToNext();
                }
            },

            child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Column(
                  children: <Widget>[
                    getText(widget.map['Questions'][widget.index]['Question'],
                        fontSize: 22),
                    Expanded(child: getWidgetByQuestion()),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            getPaddedButton("Last", () {
                              Navigator.pop(context);
                            }),
                            getPaddedButton("Next", () {
                              navigateToNext();
                            })
                          ],
                        )),
                  ],
                ))));
  }
}
