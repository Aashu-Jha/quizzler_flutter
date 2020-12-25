import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzler_flutter/quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int marks = 0;

  void checkAnswer(bool userPickedAnswer){
    bool ans = quizBrain.getAns();

    if(ans == userPickedAnswer) marks++;  //to show total marks in Alert

     setState(() {
      if (ans == userPickedAnswer)
        scoreKeeper.add(_true());
      else
        scoreKeeper.add(_false());

      if(quizBrain.nextQuestion()){
        //nothing to-do
      }
      else{
        _finishedAlert(context, marks);
        resetScoreKeeper(scoreKeeper);
        marks = 0;
        quizBrain.reset();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

//method: right answer
Icon _true(){
  return Icon(Icons.check, color: Colors.green,);
}

//method: wrong answer
Icon _false(){
  return Icon(Icons.close, color: Colors.red,);
}


//method: on finished -> Alert button
void _finishedAlert(context, int marks){
  Alert(
    context: context,
    type: AlertType.warning,
    title: "Finished",
    desc: "You've got $marks! Wanna Try Again?",
    buttons: [
      DialogButton(
        child: Text(
          "Exit",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => exit(0),
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
      DialogButton(
        child: Text(
          "Retry",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      )
    ],
  ).show();
}

void resetScoreKeeper(List<Icon> scoreKeeper){
  scoreKeeper.length = 0;
}
