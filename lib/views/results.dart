import 'package:flutter/material.dart';
import 'package:quizapp/views/home.dart';
import 'package:quizapp/widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  Results({this.correct, this.incorrect, this.total});
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.correct}/${widget.total}",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "You answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly",
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Go To Home",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
