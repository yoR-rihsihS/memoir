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
  register,
  forgotPass,
}

class _LoginState extends State<Login>
{
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";
  String userId = "";
  String _name = "";
  String _dateOfBirth = "";
 
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

  void moveToForgotPass()
  {
    formKey.currentState.reset();
    setState(()
    {
      _formType = FormType.forgotPass;
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
          print(userId);
        }
        else if(_formType == FormType.register)
        {
          String userId = await widget.auth.signUp(_email, _password, _name, _dateOfBirth);
          print(userId);
        }
        else
        {
          widget.auth.resetPassword(_email).whenComplete(()
          {
            moveToLogin();
          });
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

         new FlatButton
        (
          child: new Text("Forgot Password? Reset Password here!"),
          onPressed: moveToForgotPass,
        ),
      ];
    }
    else if(_formType == FormType.register)
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
    else
    {
      return 
      [
        new RaisedButton
        (
          child: new Text("Reset Password"),
          color: Color(0XFF4FC3F7),
          onPressed: validateAndSubmit,
        ),


        new FlatButton
        (
          child: new Text("Login here"),
          onPressed: moveToLogin,
        ),

         new FlatButton
        (
          child: new Text("Create a new account here!"),
          onPressed: moveToRegister,
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
            prefixIcon: new Icon(Icons.mail_outline),
            labelText: "E-mail",
            border: OutlineInputBorder(),
          ),
          validator:(value)
          {
            return value.isEmpty ? "Please enter a email adddress" : null;
          },
          onSaved: (value)
          {
            return _email = value.trim();
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
            prefixIcon: new Icon(Icons.lock_outline),
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
          validator:(value)
          {
            return value.isEmpty ? "Please enter password" : null;
          },
          onSaved: (value)
          {
            return _password = value.trim();
          },
        ),
          new Padding
        (
          padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
        ),
      ];
    }
    else if (_formType == FormType.register)
    {
      return
      [
        new TextFormField
        (
          decoration: InputDecoration
          (
            prefixIcon: new Icon(Icons.person_outline),
            labelText: "Name",
            border: OutlineInputBorder(),
          ),
          validator: (value)
          {
            return value.length < 3 ? "Please enter a valid name" : null;
          },
          onSaved: (value)
          {
            return _name = value.trim();
          },
        ),

        new Padding
        (
          padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
        ),

        new TextFormField
        (
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration
          (
            hintText: "25/07/1999",
            prefixIcon: new Icon(Icons.calendar_today),
            labelText: "Date Of Birth",
            border: OutlineInputBorder(),
          ),
          validator: (value)
          {
            return null;
          },
          onSaved: (value)
          {
            print(value);
            return _dateOfBirth = value.trim();
          },
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
            prefixIcon: new Icon(Icons.mail_outline),
            labelText: "E-mail",
            border: OutlineInputBorder(),
          ),
          validator:(value)
          {
            return value.isEmpty ? "Please enter a email adddress" : null;
          },
          onSaved: (value)
          {
            return _email = value.trim();
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
              prefixIcon: new Icon(Icons.lock_outline),
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            validator:(value)
            {
              return value.isEmpty ? "Please enter password" : null;
            },
            onSaved: (value)
            {
              return _password = value.trim();
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
          
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration
          (
            prefixIcon: new Icon(Icons.mail_outline),
            labelText: "E-mail",
            border: OutlineInputBorder(),
          ),
          validator:(value)
          {
            return value.isEmpty ? "Please enter a email adddress" : null;
          },
          onSaved: (value)
          {
            return _email = value.trim();
          },
        ),

      ];
    }
  }
}