import 'package:flutter/material.dart';


class Login extends StatefulWidget
{
  State<StatefulWidget> createState()
  {
    return _LoginState();
  }
}

enum FormType
{
  login,
  register
}

class _LoginState extends State<Login>
{
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";
 
  bool validate()
  {
    final form = formKey.currentState;
    if(form.validate())
    {
      form.save();
      return true;
    }
    else
    {
      return false;
    }
  }

  void moveToRegister()
  {
    formKey.currentState.reset();
    setState(()
    {
      _formType = FormType.register;
    });
  }

  void moveToLogin()
  {
    formKey.currentState.reset();
    setState(()
    {
      _formType = FormType.login;
    });
  }


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
        child: new Form
        (
          key: formKey,
          child: new Column
        (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: createForm() + createLogin()
        ),
        )
      ),
    );
  }

  List<Widget> createLogin()
  {
    if(_formType == FormType.login)
    {
      return
      [
        new RaisedButton
        (
          child: new Text("Login"),
          color: Color(0XFF4FC3F7),
          onPressed: (){print("button is pressed");},
        ),


        new FlatButton
        (
          child: new Text("Don't have an acoount? Sign up here!"),
          onPressed: moveToRegister,
        ),
      ];
    }
    else
    {
      return
      [
        new RaisedButton
        (
          child: new Text("Sign Up"),
          color: Color(0XFF4FC3F7),
          onPressed: (){print("button is pressed");},
        ),


        new FlatButton
        (
          child: new Text("Already have an acoount? Login here!"),
          onPressed: moveToLogin,
        ),
      ];
    }

  }


  List<Widget> createForm()
  {
    if(_formType == FormType.login)
    {
      return
      [
         new TextFormField
            (
              
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration
              (
                labelText: "E-mail",
                border: OutlineInputBorder(),
              ),
              validator:(value)
              {
                return value.isEmpty ? "Please enter a email adddress" : null;
              },
              onSaved: (value)
              {
                return _email = value;
              },
            ),


            new Padding
            (
              padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
            ),


            new TextFormField
            (
              obscureText: true,
              decoration: InputDecoration
              (
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              validator:(value)
              {
                return value.isEmpty ? "Please enter password" : null;
              },
              onSaved: (value)
              {
                return _password = value;
              },
            ),
             new Padding
            (
             padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
            ),
      ];
    }
    else
    {
      return
      [
        new TextFormField
        (
          decoration: InputDecoration
          (
            labelText: "Name",
            border: OutlineInputBorder(),
          ),
        ),

        new Padding
        (
          padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
        ),

        new TextFormField
        (
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration
          (
            labelText: "E-mail",
            border: OutlineInputBorder(),
          ),
          validator:(value)
          {
            return value.isEmpty ? "Please enter a email adddress" : null;
          },
          onSaved: (value)
          {
            return _email = value;
          },
          ),


          new Padding
          (
            padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
          ),


          new TextFormField
          (
            obscureText: true,
            decoration: InputDecoration
            (
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            validator:(value)
            {
              return value.isEmpty ? "Please enter password" : null;
            },
            onSaved: (value)
            {
              return _password = value;
            },
          ),


          new Padding
          (
           padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
          ),
      ];
    }
  }
}