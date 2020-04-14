import 'package:flutter/material.dart';
import 'package:memoir/authentication.dart';

class VerificationScreen extends StatelessWidget
{
  VerificationScreen
  ({
    this.auth,
    this.onVerification
  });

  final AuthImplementation auth;
  final VoidCallback onVerification;

  @override
  Widget build(BuildContext context) {
    auth.verifyUser();
    return new Scaffold
    (
      appBar: new AppBar
      (
        backgroundColor: Color(0xff292826),
        title: new Text("Verification", style: TextStyle(color: Color(0xfff9d342)),),
      ),
      body: Container
      (
        color: Color(0xffddc6b6),
        child: new Center
        (
          child: new FlatButton
          (
            child: new Text("Tap to go to Login Page!", style: TextStyle(color: Color(0xff292826), fontSize: 20.0),),
            onPressed: onVerification,
          ),
        ),
      ),
    );
  }
}