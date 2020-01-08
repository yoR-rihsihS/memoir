import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zefyr/zefyr.dart';


class ViewPage extends StatefulWidget 
{
  final String doc;
  ViewPage({this.doc});

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> 
{
  ZefyrController _controller;
  FocusNode _focusNode;


  @override
  void initState() {
    super.initState();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar
      (
        title: Text("Read Blog"),

      ),
      body: new Padding
      (
        padding: EdgeInsets.all(10.0),
        child: (_controller == null)
          ? Center(child: CircularProgressIndicator())
          : ZefyrScaffold
          (
            child: new ZefyrEditor
            (
              mode: ZefyrMode.view,
              controller: _controller,
              focusNode: _focusNode,
              imageDelegate: MyAppZefyrImageDelegate(),
            ),
          )
      ),
    );
  }

  Future<NotusDocument> _loadDocument() async
  {
    Response response;
    
    Dio dio = new Dio();
    var dir = await getTemporaryDirectory();
    try
    { 
      response = await dio.download(widget.doc, "${dir.path}/temp.json");
    }
    catch(e)
    {
      print(e);
    }
    File file = new File("${dir.path}/temp.json");

    final contents = await file.readAsString();
    print(contents);
    return NotusDocument.fromJson(jsonDecode(contents));
 

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