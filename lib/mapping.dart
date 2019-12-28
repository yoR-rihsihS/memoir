import 'package:flutter/material.dart';
import 'package:memoir/login_signup.dart';
import 'package:memoir/verification.dart';
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
  notVerified,
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

    widget.auth.getCurrentUser().then((firebaseUserId)
    {
      widget.auth.isVerified().then((onValue)
      {
        if(onValue)
        {
          setState(() {
          authStatus = AuthStatus.signedIn;
          });
        }
        else
        {
          setState(() {
          authStatus = firebaseUserId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
          });
        }
      });
    });    
  }

  void _signedIn()
  {
    widget.auth.isVerified().then((onValue)
    {
      if(onValue)
      {
        setState(() {
        authStatus = AuthStatus.signedIn;
        });
      }
      else
      {
        setState(() {
        authStatus = AuthStatus.notVerified;
        });
      }
    });
    
  }

  
  void _signedOut()
  {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  void _verification()
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
      
      case AuthStatus.notVerified:
      return new VerificationScreen(
        auth: widget.auth,
        onVerification: _verification,
      );
    }
    return new Container();
  }
}