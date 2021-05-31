import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/views/home.dart';
import 'package:quizapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp/views/create_quiz.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formkey = GlobalKey<FormState>();
  String question, option1, option2, option3, option4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Question" : null,
                decoration: InputDecoration(
                  hintText: "Question",
                ),
                onChanged: (val) {
                  question = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Option1" : null,
                decoration: InputDecoration(
                  hintText: "Option1 (Correct Answer)",
                ),
                onChanged: (val) {
                  option1 = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Option2" : null,
                decoration: InputDecoration(
                  hintText: "Option2",
                ),
                onChanged: (val) {
                  option2 = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Option3" : null,
                decoration: InputDecoration(
                  hintText: "Option3",
                ),
                onChanged: (val) {
                  option3 = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Option4" : null,
                decoration: InputDecoration(
                  hintText: "Option4",
                ),
                onChanged: (val) {
                  option4 = val;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      firestore
                          .collection('Quiz')
                          .doc(widget.quizId)
                          .collection('QNA')
                          .add({
                        'question': question,
                        'option1': option1,
                        'option2': option2,
                        'option3': option3,
                        'option4': option4,
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddQuestion(widget.quizId)));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Add Questions",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
