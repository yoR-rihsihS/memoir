import 'package:flutter/material.dart';
import 'package:memoir/authentication.dart';
import 'package:oktoast/oktoast.dart';
import 'package:regexed_validator/regexed_validator.dart';


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
        showToast(e.message, duration: Duration(seconds: 3), position: ToastPosition.bottom);
      }
    }
  }


  @override
  Widget build(BuildContext context) 
  {
    return new Container
    (
      color: Color(0xFF292826),
      child: Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>
          [
            Image.asset
            (
              "assets/logo.png",
              height: 250.0,
              width: 250.0,
            ),

            new Padding
            (
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: new Card
              (
                shape: RoundedRectangleBorder
                (
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 10.0,
                child: Padding
                (
                  padding: EdgeInsets.all(10.0),
                  child: new Form
                  (
                    autovalidate: true,
                    key: formKey,
                    child: new Column
                    (
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: createForm() + createButton()
                    ),
                  ),
                )
              ),
            )
          ],
        ),
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
          shape: RoundedRectangleBorder
          (
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: new Text
          (
            "Login",
            style: TextStyle
            (
              color: Color(0XFFf9d342),
            ),
          ),
          color: Color(0XFF292826),
          onPressed: validateAndSubmit,
        ),

        new Padding(padding: EdgeInsets.all(5.0)),

        new InkWell
        (
          child: new Text
          (
            "Don't have an acoount?",
            textAlign: TextAlign.center,
            style: TextStyle
            (
              color: Color(0xff292826),
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          onTap: moveToRegister,
        ),

        new Padding(padding: EdgeInsets.all(5.0)),

         new InkWell
        (
          child: new Text
          (
            "Forgot Password?",
            textAlign: TextAlign.center,
            style: TextStyle
            (
              color: Color(0xff292826),
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          onTap: moveToForgotPass,
        ),
      ];
    }
    else if(_formType == FormType.register)
    {
      return
      [
        new RaisedButton
        (
          shape: RoundedRectangleBorder
          (
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: new Text
          (
            "Sign Up",
            style: TextStyle
            (
              color: Color(0XFFf9d342),
            ),
          ),
          color: Color(0XFF292826),
          onPressed: validateAndSubmit,
        ),

        new Padding(padding: EdgeInsets.all(5.0)),

        new InkWell
        (
          child: new Text
          (
            "Already have an acoount?",
            textAlign: TextAlign.center,
            style: TextStyle
            (
              color: Color(0xff292826),
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          onTap: moveToLogin,
        ),
      ];
    }
    else
    {
      return 
      [
        new RaisedButton
        (
          shape: RoundedRectangleBorder
          (
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: new Text
          (
            "Reset Password",
            style: TextStyle
            (
              color: Color(0XFFf9d342),
            ),
          ),
          color: Color(0XFF292826),
          onPressed: validateAndSubmit,
        ),

        new Padding(padding: EdgeInsets.all(5.0)),

        new InkWell
        (
          child: new Text
          (
            "Login here!",
            textAlign: TextAlign.center,
            style: TextStyle
            (
              color: Color(0xff292826),
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          onTap: moveToLogin,
        ),

        new Padding(padding: EdgeInsets.all(5.0)),

        new InkWell
        (
          child: new Text
          (
            "Create a new account here!",
            textAlign: TextAlign.center,
            style: TextStyle
            (
              color: Color(0xff292826),
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          onTap: moveToRegister,
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
            prefixIcon: new Icon(Icons.mail_outline, color: Color(0xff292826),),
            labelText: "E-mail",
            border: OutlineInputBorder
            (
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          validator:(value)
          {
            return ! validator.email(value) ? "Please enter a valid email" : null;
          },
          onSaved: (value)
          {
            return _email = value.trim();
          },
        ),


        new Padding
        (
          padding: EdgeInsets.all(5.0),
        ),


        new TextFormField
        (
          obscureText: true,
          decoration: InputDecoration
          (
            prefixIcon: new Icon(Icons.lock_outline, color: Color(0xff292826),),
            labelText: "Password",
            border: OutlineInputBorder
            (
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          validator:(value)
          {
            return ! validator.password(value) ? "Password must contain atleast 8 characters containing capital-small letter, number and special symbol" : null;
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
            prefixIcon: new Icon(Icons.person_outline, color: Color(0xff292826),),
            labelText: "Name Example",
            border: OutlineInputBorder
            (
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          validator: (value)
          {
            return ! validator.name(value) ? "Please enter a valid name" : null;
          },
          onSaved: (value)
          {
            return _name = value.trim();
          },
        ),

        new Padding
        (
          padding: EdgeInsets.all(5.0)
        ),

        new TextFormField
        (
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration
          (
            hintText: "1999/07-25",
            prefixIcon: new Icon(Icons.calendar_today, color: Color(0xff292826),),
            labelText: "Date Of Birth",
            border: OutlineInputBorder
            (
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          validator: (value)
          {
            return ! validator.date(value) ? "Please enter a valid date" : null;
          },
          onSaved: (value)
          {
            print(value);
            return _dateOfBirth = value.trim();
          },
        ),

        new Padding
        (
          padding: EdgeInsets.all(5.0)
        ),

        new TextFormField
        (
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration
          (
            prefixIcon: new Icon(Icons.mail_outline, color: Color(0xff292826),),
            labelText: "E-mail",
            border: OutlineInputBorder
            (
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          validator:(value)
          {
            return ! validator.email(value) ? "Please enter a valid email" : null;
          },
          onSaved: (value)
          {
            return _email = value.trim();
          },
          ),


          new Padding
          (
            padding: EdgeInsets.all(5.0)
          ),


          new TextFormField
          (
            obscureText: true,
            decoration: InputDecoration
            (
              prefixIcon: new Icon(Icons.lock_outline, color: Color(0xff292826),),
              labelText: "Password",
              border: OutlineInputBorder
              (
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator:(value)
            {
            return ! validator.password(value) ? "Password must contain atleast 8 characters containing capital-small letter, number and special symbol" : null;
            },
            onSaved: (value)
            {
              return _password = value.trim();
            },
          ),


          new Padding
          (
           padding: EdgeInsets.all(5.0)
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
            prefixIcon: new Icon(Icons.mail_outline, color: Color(0xff292826),),
            labelText: "E-mail",
            border: OutlineInputBorder
            (
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          validator:(value)
          {
            return ! validator.email(value) ? "Please enter a valid email" : null;
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