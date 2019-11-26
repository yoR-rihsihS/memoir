import 'package:flutter/material.dart';


class Login extends StatefulWidget
{
  State<StatefulWidget> createState()
  {
    return _LoginState();
  }
}

class _LoginState extends State<Login>
{
   @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: new AppBar
      (
        centerTitle: true,
        title: new Text("Memoir"),
      ),
      body: new Padding
      (
        padding: EdgeInsets.all(15.0),
        child: new Column
        (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>
          [
            new TextField
            (
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration
              (
                labelText: "Enter your E-mail id here!",
                border: OutlineInputBorder(),
              ),
            ),
            new Padding( padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)),
            new TextField
            (
              obscureText: true,
              decoration: InputDecoration
              (
                labelText: "Enter your password here!",
                border: OutlineInputBorder(),
              ),
            ),
            new Padding( padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)),
            new RaisedButton
            (
              child: new Text("Login"),
              color: Color(0XFF4FC3F7),
              onPressed: (){print("button is pressed");},
            ),
            new FlatButton
            (
              child: new Text("Don't have an acoount? Sign up here!"),
              onPressed: (){print("button is pressed");},
            )
          ],
        ),
      ),

    );
  }
}