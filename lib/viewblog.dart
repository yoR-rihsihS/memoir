import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
        child: new ZefyrScaffold
        (
          child: new ZefyrEditor
          (
            mode: ZefyrMode.view,
            controller: _controller,
            focusNode: _focusNode,

          ),
        )
      ),
    );
  }

  Future<NotusDocument> _loadDocument() async
  {
    String document;
    

    return NotusDocument.fromJson(jsonDecode(document));
  }
}