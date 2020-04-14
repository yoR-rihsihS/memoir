import 'package:flutter/material.dart';
import 'mapping.dart';
import 'authentication.dart';
import 'package:oktoast/oktoast.dart';


void main() => runApp(Memoir());

class Memoir extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new OKToast(
      child: new MaterialApp
        (
          title: "Memoir",
          home: MappingPage(auth: Auth(),),
        ),
    );
  }
}