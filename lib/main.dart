import 'package:flutter/material.dart';
import 'login_signup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp
    (
      title: "Memoir",
      home: Login(),
    );
  }
}