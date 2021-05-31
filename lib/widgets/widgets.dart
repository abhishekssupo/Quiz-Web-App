import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(style: TextStyle(fontSize: 22), children: <TextSpan>[
      TextSpan(
        text: 'Quiz',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
      TextSpan(
        text: 'WebApp',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    ]),
  );
}

Widget blueButton(BuildContext context, String label) {
  Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    alignment: Alignment.center,
    height: 10,
    width: MediaQuery.of(context).size.width - 48,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
