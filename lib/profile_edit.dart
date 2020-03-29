import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memoir/authentication.dart';
import 'package:oktoast/oktoast.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';



class ProfileEdit extends StatefulWidget {

  final AuthImplementation auth;
  final String uid;
  final String mobile;
  final String bio;
  final String dob;
  final String propic;
  final String name;

  ProfileEdit
  ({
    this.auth,
    this.name,
    this.uid,
    this.propic,
    this.bio,
    this.dob,
    this.mobile,
  });

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {

  DatabaseReference userRef = FirebaseDatabase.instance.reference().child("Users");
  final formKey = new GlobalKey<FormState>();
  String mobile;
  String bio;
  String dob;
  String propic;
  String name;
  String userKey;

  @override
  void initState() { 
    super.initState();
    propic = widget.propic;
    userRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      for(var individualKey in KEYS)
      {
        if(DATA[individualKey]['uid'] == widget.uid)
        {
          userKey = individualKey;
        }
      }
    });
  }

  Future<String> uploadPhoto() async
  {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    var result = await FlutterImageCompress.compressWithFile
    (
      file.absolute.path,
      minWidth: 1920,
      minHeight: 1080,
      quality: 80,
    );
    file.writeAsBytes(result, flush: true, mode: FileMode.write);
    final StorageReference postImageRef = FirebaseStorage.instance.ref().child("ProPic");
    final StorageUploadTask uploadTask = postImageRef.child(widget.uid + ".jpg").putFile(file);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return imageUrl.toString();
  }

  void setProPic() async
  {
    String temp = await uploadPhoto(); 
    setState(() {
      propic = temp;
    });
    try
    {
      var data = {"propic": propic,};
      userRef.child(userKey).update(data); 
    }
    catch(e)
    {
      showToast(e.message, duration: Duration(seconds: 3), position: ToastPosition.bottom);
    }
  }

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

  void validateAndSubmit() async
  {
    if(validateAndSave())
    {
      try
      {
        var data =
        {
          "name": name,
          "bio": bio,
          "dob": dob,
          "mobile": mobile,
        };
        userRef.child(userKey).update(data).whenComplete(()
        {
          Navigator.pop(context);
        });
      }
      catch(e)
      {
        showToast(e.message, duration: Duration(seconds: 3), position: ToastPosition.bottom);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: new AppBar
      (
        title: Text("Edit Profile"),
        actions: <Widget>
        [
          IconButton(icon: Icon(Icons.done), onPressed: validateAndSubmit),
        ],
      ),

      body: new Column
      (
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>
        [
          new Align
          (
            alignment: Alignment.topCenter,
            child: new SizedBox
            (
              height: 185,
              width: 185,
              child: new Padding
              (
                padding: EdgeInsets.all(10.0),
                child: new CircleAvatar
                (
                  radius: 80.5,
                  backgroundColor: Colors.blue[400],
                  child: propic == null ? new Icon(Icons.person, size: 150.0,) : new CircleAvatar
                  (
                    radius: 80,
                    backgroundImage: NetworkImage(propic),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          new Padding
          (
            padding: EdgeInsets.all(10.0),
            child: new InkWell
            (
              focusColor: Colors.blue,
              child: new Text("Upload a new photo", style: TextStyle(color: Colors.blueAccent),),
              onTap: setProPic,
            ),
          ),

          new Divider(),

          new Form
          (
            autovalidate: true,
            key: formKey,
            child: new Column
            (
              children: <Widget>
              [
                Padding
                (
                  padding: EdgeInsets.all(10.0),
                  child: new TextFormField
                  (
                    keyboardType: TextInputType.text,
                    initialValue: widget.name,
                    decoration: InputDecoration
                    (
                      labelText: "Name",
                    ),
                    validator: (value)
                    {
                      return ! validator.name(value) ? "Please enter a valid name" : null;
                    },
                    onSaved: (value)
                    {
                      return name = value;
                    },
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(10.0),
                  child: new TextFormField
                  (
                    keyboardType: TextInputType.datetime,
                    initialValue: widget.dob,
                    decoration: InputDecoration
                    (
                      labelText: "Date of Birth",
                    ),
                    validator: (value)
                    {
                      return ! validator.date(value) ? "Please enter a valid date" : null;
                    },
                    onSaved: (value)
                    {
                      return dob = value;
                    },
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(10.0),
                  child: new TextFormField
                  (
                    maxLength: 250,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    initialValue: widget.bio,
                    decoration: InputDecoration
                    (
                      labelText: "Bio",
                    ),
                    validator: (value)
                    {
                      return null;
                    },
                    onSaved: (value)
                    {
                      return bio = value;
                    },
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(10.0),
                  child: new TextFormField
                  (
                    keyboardType: TextInputType.number,
                    initialValue: widget.mobile,
                    decoration: InputDecoration
                    (
                      labelText: "Phone Number",
                    ),
                    validator: (value)
                    {
                      return ! validator.phone(value) ? "Please enter a valid phone number" : null;
                    },
                    onSaved: (value)
                    {
                      return mobile = value;
                    },
                  ),
                ),
              ],
            )
          ),
        ]
      )
    );
  }
}