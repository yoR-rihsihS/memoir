import 'package:flutter/material.dart';
import 'mapping.dart';
import 'authentication.dart';



void main() => runApp(Memoir());

class Memoir extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp
    (
      title: "Memoir",
      home: MappingPage(auth: Auth(),),
    );
  }
}