import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/views/home.dart';
import 'package:quizapp/views/signin.dart';
import 'package:quizapp/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email, password, name;
  AuthServices authServices;
  bool isLoading = false;
  signUp() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authServices.signUpWithEmailAndPassword(email, password).then((value) {
        if (value != null) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
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
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Spacer(),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Enter Name" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                  onChanged: (val) {
                    name = val;
                  },
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Enter Email" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                  onChanged: (val) {
                    email = val;
                  },
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  validator: (val) {
                    return val.isEmpty ? "Enter Password" : null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  onChanged: (val) {
                    password = val;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      UserCredential new_user =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (new_user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      print(e);
                    }
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
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text(
                        "sign In",
                        style: TextStyle(
                            fontSize: 16, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
