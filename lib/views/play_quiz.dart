import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/models/question_model.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/results.dart';
import 'package:quizapp/widgets/widgets.dart';
import 'package:quizapp/widgets/question_tile.dart';

final _firestore = FirebaseFirestore.instance;

int total = 0;
int correct = 0;
int incorrect = 0;
int notAttempted = 0;

Stream infoStream;

class PlayQuiz extends StatefulWidget {
  final String quizId;

  PlayQuiz(this.quizId);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot querySnapshot;
  bool isLoading = true;
  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();
    questionModel.question = questionSnapshot.data()['question'];
    List<String> options = [
      questionSnapshot.data()['option1'],
      questionSnapshot.data()['option2'],
      questionSnapshot.data()['option3'],
      questionSnapshot.data()['option4'],
    ];
    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.data()['option1'];
    questionModel.answered = false;
    return questionModel;
  }

  @override
  void initState() {
    databaseService.getQuestionData(widget.quizId).then((val) {
      querySnapshot = val;
      correct = 0;
      incorrect = 0;
      notAttempted = 0;
      isLoading = false;
      total = querySnapshot.docs.length;
      print("${widget.quizId}");
      setState(() {});
    });
    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        return [correct, incorrect];
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: querySnapshot == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: querySnapshot.docs.length,
                itemBuilder: (context, index) {
                  return QuizPlayTile(
                    questionModel: getQuestionModelFromDatasnapshot(
                        querySnapshot.docs[index]),
                    index: index,
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                        correct: correct,
                        incorrect: incorrect,
                        total: total,
                      )));
        },
      ),
    );
  }
}

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  OptionTile(
      {this.optionSelected, this.correctAnswer, this.description, this.option});
  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.description == widget.optionSelected
                    ? widget.optionSelected == widget.correctAnswer
                        ? Colors.green.withOpacity(0.7)
                        : Colors.red.withOpacity(0.7)
                    : Colors.grey,
                width: 1.5,
              ),
              color: widget.optionSelected == widget.description
                  ? widget.description == widget.correctAnswer
                      ? Colors.green.withOpacity(0.7)
                      : Colors.red.withOpacity(0.7)
                  : Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              "${widget.option}",
              style: TextStyle(
                color: widget.optionSelected == widget.description
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            widget.description,
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({this.questionModel, this.index});
  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1}  ${widget.questionModel.question}",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  correct += 1;
                  notAttempted -= 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  incorrect += 1;
                  notAttempted -= 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option1,
              option: "A",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 7,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  correct += 1;
                  notAttempted -= 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  incorrect += 1;
                  notAttempted -= 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option2,
              option: "B",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 7,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  correct += 1;
                  notAttempted -= 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  incorrect += 1;
                  notAttempted -= 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option3,
              option: "C",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 7,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  correct += 1;
                  notAttempted -= 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  incorrect += 1;
                  notAttempted -= 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option4,
              option: "D",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class QuestionStreams extends StatelessWidget {
  final String quizId;
  QuestionStreams({this.quizId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('Quiz')
          .doc(quizId)
          .collection('QNA')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ));
        }
        final quizQuestions = snapshot.data.docs;
        List<QuizPlayTile> quizztWidget = [];
        for (var quizQuestion in quizQuestions) {
          var quizData = quizQuestion.data();
          final quizQ = quizData['question'];
          final quizoption1 = quizData['option1'];
          final quizoption2 = quizData['option2'];
          final quizoption3 = quizData['option3'];
          final quizoption4 = quizData['option4'];
          List<String> options = [
            quizoption1,
            quizoption2,
            quizoption3,
            quizoption4
          ];
          options.shuffle();
          //var currentUser = loggedInUser.email;
          QuestionModel questionModel;
          questionModel.question = quizQ;
          questionModel.option1 = options[0];
          questionModel.option2 = options[1];
          questionModel.option3 = options[2];
          questionModel.option4 = options[3];
          questionModel.correctOption = quizoption1;
          questionModel.answered = false;
          final quizWidget = QuizPlayTile(
            questionModel: questionModel,
          );
          quizztWidget.add(quizWidget);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: quizztWidget,
          ),
        );
      },
    );
  }
}
