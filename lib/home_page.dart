import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:memoir/page_content.dart';
import 'package:oktoast/oktoast.dart';
import 'authentication.dart';
import 'editor.dart';
import 'posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progressive_image/progressive_image.dart';



class HomePage extends StatefulWidget
{
  HomePage({
    this.auth,
    this.onSignedOut,
  });
  
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  State<StatefulWidget> createState()
  {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>
{
 
  
  int _currentIndex = 0;
  final List<Widget> _children = 
  [
    PageContent(index: 1,),
    PageContent(index: 2,),
    PageContent(index: 3,),
  ];
  String name = "";
  String bio = "";
  String uid = "";
  List<Posts> postsList = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() 
  {
    super.initState();
    
    widget.auth.getCurrentUser().then((firebaseUserID)
    {
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child("Users");
      userRef.once().then((DataSnapshot snap)
      {
        var KEYS = snap.value.keys;
        var DATA = snap.value;
        for(var individualKey in KEYS)
        {
          if (DATA[individualKey]['uid'] == firebaseUserID)
          {
            name = DATA[individualKey]['name'];
            bio = DATA[individualKey]['bio'];
            uid = DATA[individualKey]['uid'];
            print(uid);
          }
        }
      });
    });

    
    
  }

 


  void _logOutUser() async
  {
    try
    {
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e)
    {
      showToast(e.message, duration: Duration(seconds: 3), position: ToastPosition.bottom);
    }
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: new AppBar
      (
        title: new Text("Home Page"),
        actions: <Widget>
        [
          new IconButton(icon: new Icon(Icons.pets), onPressed: _logOutUser),
        ],
      ),

      

      body: _children[_currentIndex],
      
      
      bottomNavigationBar: new BottomNavigationBar
      (
        onTap: onTabTapped, 
        currentIndex: _currentIndex,
        items: [
         new BottomNavigationBarItem
         (
           icon: Icon(Icons.home),
           title: Text('Home'),
         ),
         new BottomNavigationBarItem
         (
           icon: Icon(Icons.add_photo_alternate),
           title: Text('Post'),
         ),
         new BottomNavigationBarItem
         (
           icon: Icon(Icons.account_circle),
           title: Text('Profile')
         )
       ], 
      ),
    );
  }
}