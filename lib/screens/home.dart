import 'package:calculator_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer = '';

  final List<String> buttons = [
    'C',
    'Del',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '000',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: [
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.065),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      userQuestion,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userAnswer,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ]),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return MyButton(
                    buttonTapped: () {
                      setState(() {
                        userQuestion = '';
                        userAnswer = '';
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.green,
                    textColor: Colors.white,
                  );
                } else if (index == 1) {
                  return MyButton(
                    buttonTapped: () {
                      setState(() {
                        userQuestion =
                            userQuestion.substring(0, userQuestion.length - 1);
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.red,
                    textColor: Colors.white,
                  );
                } else if (index == 19) {
                  return MyButton(
                    buttonTapped: () {
                      setState(() {
                        equelPressed();
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                  );
                } else if (index == 2) {
                  return MyButton(
                    buttonTapped: () {
                      setState(() {
                        // prevent double operator, but you can add % after +,*,-,/
                        if (userQuestion.endsWith('%/') ||
                            userQuestion.endsWith('%x') ||
                            userQuestion.endsWith('%-') ||
                            userQuestion.endsWith('%+')) {
                          userQuestion = userQuestion.substring(
                              0, userQuestion.length - 2);
                        } else if (userQuestion.endsWith('%') ||
                            userQuestion.endsWith('/') ||
                            userQuestion.endsWith('x') ||
                            userQuestion.endsWith('-') ||
                            userQuestion.endsWith('+')) {
                          userQuestion = userQuestion.substring(
                              0, userQuestion.length - 1);
                        }
                        userQuestion += buttons[index];
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                  );
                } else if (index == 3 ||
                    index == 7 ||
                    index == 11 ||
                    index == 15) {
                  return MyButton(
                    buttonTapped: () {
                      setState(() {
                        // prevent double operator
                        if (userQuestion.endsWith('/') ||
                            userQuestion.endsWith('x') ||
                            userQuestion.endsWith('-') ||
                            userQuestion.endsWith('+')) {
                          userQuestion = userQuestion.substring(
                              0, userQuestion.length - 1);
                        }
                        userQuestion += buttons[index];
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                  );
                } else {
                  return MyButton(
                    buttonTapped: () {
                      setState(() {
                        userQuestion += buttons[index];
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.deepPurple[50],
                    textColor: Colors.deepPurple,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // remove unneceassary trailing zeros
  removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }

  void equelPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*'); // replacing x with *
    finalQuestion =
        finalQuestion.replaceAll('%', '*0.01'); // replacing % with *0.01
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    userAnswer = removeTrailingZeros(eval.toString());
  }
}
