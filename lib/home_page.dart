import 'package:flutter/material.dart';
import 'authentication.dart';

class HomePage extends StatefulWidget
{
  HomePage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  State<StatefulWidget> createState()
  {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>
{
  void _logOutUser() async
  {
    try
    {
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e)
    {
      print("Error ="+ e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: new AppBar
      (
        title: Text("Home Page"),
      ),
      body: new Container
      (

      ),
      bottomNavigationBar: new BottomAppBar
      (
        color: Colors.lightBlueAccent,
        child: new Row
        (
          children: <Widget>
          [
            new IconButton
            (
              icon: new Icon(Icons.account_circle),
              onPressed: _logOutUser,
            ),
          ],
        ),
      ),
    );
  }
}