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
        title: new Text("Verification"),
      ),
      body: new Center
      (
        child: new FlatButton
        (
          child: new Text("Verification Email sent to your Mail. Tap to Login!"),
          onPressed: onVerification,
        ),
      ),
    );
  }
}