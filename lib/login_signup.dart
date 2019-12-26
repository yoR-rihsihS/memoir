import 'package:flutter/material.dart';
import 'package:memoir/authentication.dart';


class Login extends StatefulWidget
{
  Login({
    this.auth,
    this.onSignedIn,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

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
  // final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";
  String userId = "";
 
  bool validateAndSave()
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

  void validateAndSubmit() async
  {
    if(validateAndSave())
    {
      try
      {
        if(_formType == FormType.login)
        {
          String userId = await widget.auth.signIn(_email, _password);
          // final snackBar = SnackBar(content: Text('You have been logged in sucessfully'), duration: Duration(seconds: 3),);
          // _scaffoldKey.currentState.showSnackBar(snackBar);
          print(userId);
        }
        else
        {
          String userId = await widget.auth.signUp(_email, _password);
          print(userId);
          // Scaffold.of(context).showSnackBar(
          // SnackBar(
          //   content: Text('You have signed up sucessfully'),
          //   duration: Duration(seconds: 3),
          // ));
        }

        widget.onSignedIn();
      }
      catch(e)
      {
        print("Error =" + e.toString());
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      // key: _scaffoldKey,
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
          children: createForm() + createButton()
        ),
        )
      ),
    );
  }

  List<Widget> createButton()
  {
    if(_formType == FormType.login)
    {
      return
      [
        new RaisedButton
        (
          child: new Text("Login"),
          color: Color(0XFF4FC3F7),
          onPressed: validateAndSubmit,
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
          onPressed: validateAndSubmit,
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