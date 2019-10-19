import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Survey_Question extends StatefulWidget {
  Map map;
  int index;
  String surveyName;
  List<String> disabledValues;

  Survey_Question({Key key, @required this.map, @required this.index, @required this.disabledValues})
      : super(key: key);

  @override
  Survey_Question_State createState() => Survey_Question_State();
}

class Survey_Question_State extends State<Survey_Question> {
  Widget getWidgetByQuestion()
  {
    Map question = widget.map['Questions'][widget.index];
    switch(question['QuestionType'])
    {
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

  Widget getDisabler(Map question)
  {
    String radioGroupValue;
    question['Answers'].remove("-1");

    if(question['Answers'].length != 0)
      {
        if(question['UserAnswer'] != "")
        {
          radioGroupValue = question['UserAnswers'];
        }
        else
        {
          radioGroupValue = question['Answers'][0];
        }
      }

    return new ListView.builder(itemBuilder: (BuildContext context, int index){
      if(index == 0)
        {
          return Text(question['Question']);
        }

      else if(index == 1)
        {
          return Divider();
        }

      else
        {
          index = index - 2;
          return Radio<String>(
            value: question['Answers'][index],
            groupValue: radioGroupValue,
            onChanged: (String value){
              setState(() {
                question['UserAnswers'] = value;
                radioGroupValue = value;
                // Todo Find a better way to detect if you are disabling or not
                if(value == 'No')
                  {
                    widget.disabledValues.add(question['Category']);
                  }
                
                else if(value == 'Yes')
                  {
                    widget.disabledValues.retainWhere((item) => item == question['Category']);
                  }
              });
            },
          );
        }
    },

      itemCount: 4,
    );
  }


  Widget getMultipleChoiceRadio(Map question)
  {


  }

  Widget getMultipleChoice(Map question)
  {

  }

  Widget getFillInTheBlank(Map question)
  {

  }

  Widget getScaryWidget(Map question)
  {

  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Survey"),
        ),
        body: getWidgetByQuestion());
  }
}
