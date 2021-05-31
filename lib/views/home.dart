import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/create_quiz.dart';
import 'package:quizapp/views/play_quiz.dart';
import 'package:quizapp/widgets/widgets.dart';

final _firestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('Quiz').snapshots();
  DatabaseService databaseService;
  Stream quizStream;
  Widget quizList() {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                      imgUrl: snapshot.data.docs[index].data["quizImgUrl"],
                      title: snapshot.data.docs[index].data["quizTitle"],
                      desc: snapshot.data.docs[index].data["quizDesc"],
                    );
                  });
        },
      ),
    );
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
      body: SafeArea(
        child: Column(
          children: [
            QuizStreams(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }
}

class QuizStreams extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Quiz').snapshots(),
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
          final quizs = snapshot.data.docs;
          List<QuizTile> quizztWidget = [];
          for (var quiz in quizs) {
            var quizData = quiz.data();
            final quizimg = quizData['quizImgUrl'];
            final quiztitle = quizData['quizTitle'];
            final quizdesc = quizData['quizDesc'];
            final quizid = quizData['quizId'];
            //var currentUser = loggedInUser.email;
            final quizWidget = QuizTile(
              imgUrl: quizimg,
              title: quiztitle,
              desc: quizdesc,
              quizId: quizid,
            );
            quizztWidget.add(quizWidget);
          }
          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: quizztWidget,
            ),
          );
        });
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl, title, desc, quizId;
  QuizTile({this.imgUrl, this.title, this.desc, this.quizId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayQuiz(quizId)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
