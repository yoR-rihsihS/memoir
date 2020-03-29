import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';



class EditorPage extends StatefulWidget 
{
  final String name;
  final String uId;
  final VoidCallback onPostUpload;

  EditorPage({this.name , this.uId, this.onPostUpload});

  @override
  EditorPageState createState() => EditorPageState();
}


class EditorPageState extends State<EditorPage> 
{
  String _url;
  TextEditingController _cont;
  String preview;
  String image;
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() 
  {
    super.initState();
    _cont = new TextEditingController();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  void _onPostUpdate()
  {
    widget.onPostUpload();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
      (
        title: Text("Editor"),
        actions: <Widget>
        [
          new IconButton
          (
            icon: Icon(Icons.library_books),
            onPressed: ()
            {
              setState(() {
                _saveDocument(context);
              });
            },
          ),
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          mode: ZefyrMode.edit,
          padding: EdgeInsets.all(10.0),
          controller: _controller,
          focusNode: _focusNode,
          imageDelegate: MyAppZefyrImageDelegate(),
        ),
      ),
    );
  }


  NotusDocument _loadDocument() 
  {
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }


  void _saveDocument(BuildContext context) async
  {
    await Alert
    (
      context: context,
      title: "POST",
      content: Column(
        children: <Widget>[
          TextField(
            maxLines: null,
            controller: _cont,
            decoration: InputDecoration(
              icon: Icon(Icons.title),
              labelText: 'Enter Title here',
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: ()
          {
            uploadDoc();
            setState(()
            {
              this.preview = _cont.text;
            });
            Navigator.pop(context);
          },
          child: Text(
            "POST",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]
    ).show();
  }
  

  void uploadDoc() async
  {
    final contents = jsonEncode(_controller.document);
    if (contents.contains("image"))
    {
      image = contents.substring(contents.indexOf("https") , contents.indexOf("}}}") - 1);
    }
    else
    {
      image = null;
    }
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Posts");

    var timeKey = new DateTime.now();
    File post = await file.writeAsString(contents);
    final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".json").putFile(post);
  
    var postUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    _url = postUrl.toString();

    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('d, M, y');
    var formatTime = new DateFormat('H:m');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    var data = 
    {
      "preview" : preview,
      "image" : image,
      "uId" : widget.uId,
      "post" : _url,
      "date" : date,
      "time" : time,
      "name" : widget.name,
    };

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child("Posts").push().set(data); 

    _onPostUpdate();
  }

}




class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> 
{
  @override
  Future<String> pickImage(ImageSource source) async 
  {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) 
    {
      return null;
    }
    else{
      var result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 1920,
        minHeight: 1080,
        quality: 80,
      );
      file.writeAsBytes(result, flush: true, mode: FileMode.write);
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Images");

      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(file);

      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      return imageUrl.toString();
    }
  }


  @override
  Widget buildImage(BuildContext context, String key) 
  {
    return ProgressiveImage
    (
      blur: 10.0,
      placeholder: AssetImage("assets/placeholder.jpg"),
      thumbnail: AssetImage("assets/placeholder.jpg"),
      image: NetworkImage(key),
      width: 1920,
      height: 1080,
      fit: BoxFit.scaleDown,
    );
  }


  @override
  ImageSource get cameraSource => ImageSource.camera;


  @override
  ImageSource get gallerySource => ImageSource.gallery;
}