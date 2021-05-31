import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String initUserEmail, initUserName, initUserImage;
  String get getInitUserName => initUserName;
  String get getInitUserEmail => initUserEmail;
  String get getInitUserImage => initUserImage;
  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getQuizData() async {
    return await FirebaseFirestore.instance.collection('Quiz').snapshots();
  }

  getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('Quiz')
        .doc('quizId')
        .get()
        .then((doc) {
      print('Fetching user data');
      initUserName = doc.data()['quizImgUrl'];
      initUserEmail = doc.data()['quizTitle'];
      initUserImage = doc.data()['quizDesc'];
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
    });
  }
}
