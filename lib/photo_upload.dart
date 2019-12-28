import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';



class UploadPhoto extends StatefulWidget
{
  final String name;

  UploadPhoto({this.name});

  @override
  State<StatefulWidget> createState() {
    return _UploadPhotoState();
  }
}


class _UploadPhotoState extends State<UploadPhoto>
{
  File sampleImage;
  String _description;
  String _url;
  
  final formKey = new GlobalKey<FormState>();
  
  Future selectImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    List<int> image = await testCompressFile(tempImage);
    tempImage.writeAsBytes(image, flush: true, mode: FileMode.write);
    setState(() {
      sampleImage = tempImage;
    });
  }

  Future<List<int>> testCompressFile(File file) async 
  {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1920,
      minHeight: 1080,
      quality: 90,
    );
    return result;
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

  void uploadPost() async
  {
    if(validateAndSave())
    {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Images");

      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      _url = imageUrl.toString();

      print(_url);

      saveToDatabase(_url);
      goToHomePage();
    }
  }

  void saveToDatabase(_url)
  {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('d, M, y');
    var formatTime = new DateFormat('H:m');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = 
    {
      "image" : _url,
      "description" : _description,
      "date" : date,
      "time" : time,
      "name" : widget.name,
    };

    ref.child("Posts").push().set(data);
  }

  void goToHomePage()
  {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold
    (
      appBar: new AppBar
      (
        title: Text("Upload Background Image"),
      ),
      body: new Center
      (
        child: sampleImage == null ? Text("Please select an Image") : writePost(),
      ),
      floatingActionButton: new FloatingActionButton
      (
        child: new Icon(Icons.add_a_photo),
        onPressed: selectImage,
      ),
    );
  }


  Widget writePost()
  {
    return new Container
    (
      child: new Padding
      (
        padding: EdgeInsets.all(15.0),
        child: new Form
        (
          key: formKey,
          child: new Column
          (
            children: <Widget>
            [
              Image.file(sampleImage),

                new Padding
              (
                padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
              ),

              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Please add a description",
                  border: OutlineInputBorder(),
                ),
                validator:(value)
                {
                  return value.isEmpty ? "Please enter description" : null;
                },
                onSaved: (value)
                {
                  return _description = value;
                },
              ),

                new Padding
              (
                padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,10.0)
              ),

              RaisedButton
              (
                child: Text("Publish"),
                color: Color(0XFF4FC3F7),
                onPressed: uploadPost, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}