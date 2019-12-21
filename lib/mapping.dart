import 'package:flutter/material.dart';
import 'package:memoir/login_signup.dart';
import 'home_page.dart';
import 'authentication.dart';

class MappingPage extends StatefulWidget
{
  final AuthImplementation auth;

  MappingPage
  ({
    this.auth,
  });

  State<StatefulWidget> createState()
  {
    return _MappingPageState();
  }
}


enum AuthStatus
{
  signedIn,
  notSignedIn,
}

class _MappingPageState extends State<MappingPage>
{
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() 
  {
    super.initState();

    widget.auth.currentUser().then((firebaseUserId)
    {
      setState(() {
        authStatus = firebaseUserId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn()
  {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut()
  {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus)
    {
      case AuthStatus.notSignedIn:
      return new Login(
        auth: widget.auth,
        onSignedIn: _signedIn,
      );
      
      case AuthStatus.signedIn:
      return new HomePage(
        auth: widget.auth,
        onSignedOut: _signedOut,
      );
    }
    return null;
  }
}