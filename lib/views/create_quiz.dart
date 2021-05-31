import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/addQuestion.dart';
import 'package:quizapp/widgets/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key key}) : super(key: key);

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formkey = GlobalKey<FormState>();
  String quizImageUrl, quizTitle, quizDescription, quizId;
  DatabaseService databaseService;
  bool _isLoading = false;
  createQuizOnline() async {
    if (_formkey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(16);
      Map<String, String> quizData = {
        "quizId": quizId,
        "quizImgUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDescription
      };
    }
  }

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
                validator: (val) => val.isEmpty ? "Enter Url" : null,
                decoration: InputDecoration(
                  hintText: "Quiz Image Url",
                ),
                onChanged: (val) {
                  quizImageUrl = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter Quiz Title" : null,
                decoration: InputDecoration(
                  hintText: "Quiz Title",
                ),
                onChanged: (val) {
                  quizTitle = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? "Enter Quiz Description" : null,
                decoration: InputDecoration(
                  hintText: "Quiz Description",
                ),
                onChanged: (val) {
                  quizDescription = val;
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  quizId = randomAlphaNumeric(16);
                  firestore.collection('Quiz').doc(quizId).set({
                    'quizId': quizId,
                    'quizImgUrl': quizImageUrl,
                    'quizTitle': quizTitle,
                    'quizDesc': quizDescription,
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddQuestion(quizId)));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 48,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
