import 'package:flutter/material.dart';

class HomePage extends StatefulWidget
{
  State<StatefulWidget> createState()
  {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>
{
  void _logOutUser()
  {
    print("button is pressed");
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