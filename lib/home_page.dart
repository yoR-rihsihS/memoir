import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:memoir/page_content.dart';
import 'package:memoir/profile_edit.dart';
import 'package:oktoast/oktoast.dart';
import 'authentication.dart';
import 'editor.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';


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
  PageController _pageController;
  String title = 'Home Page';
  int _currentIndex = 0;
  String name = "";
  String uid = "";
  String dob = "";
  String propic = "";
  String bio = "";
  String mobile = "";
  String email = "";


  void postUpload()
  {
    setState(() {
      _currentIndex = 0;
      _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }


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
            uid = DATA[individualKey]['uid'];
            dob = DATA[individualKey]['dob'];
            propic = DATA[individualKey]['propic'];
            mobile = DATA[individualKey]['mobile'];
            bio = DATA[individualKey]['bio'];
          }
        }
      });
    });
    _pageController = PageController();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: _currentIndex == 1 ? null : new AppBar
      (
        title: new Text(title),
        actions: <Widget>
        [
          new IconButton(icon: new Icon(Icons.edit), onPressed: (){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileEdit
            (
              auth: widget.auth,
              uid: uid,
              name: name,
              propic: propic,
              mobile: mobile,
              dob: dob,
              bio: bio,
            )
            ),
          );
          }),
          new IconButton(icon: new Icon(Icons.pets), onPressed: _logOutUser),
        ],
      ),

      body: new SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            PageContent(index: 1,),
            EditorPage(name: name, uId: uid, onPostUpload: postUpload,),
            PageContent(index: 3,),
          ],
        ),
      ),
      
      
      bottomNavigationBar: new BottomNavyBar
      (
        showElevation: true, 
        onItemSelected: (index) => setState(() {
                    _currentIndex = index;
                    switch (index){
                      case 2: title = "My Profile";
                      break;
                      case 1: title = "Editor";
                      break;
                      case 0: title = "Home Page";
                      break;
                    }
                    _pageController.animateToPage(index,
                        duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        selectedIndex: _currentIndex,
        items: [
         new BottomNavyBarItem
         (
           icon: Icon(Icons.home),
           title: new Text(title),
         ),
         new BottomNavyBarItem
         (
           icon: Icon(Icons.add_photo_alternate),
           title: Text('Post'),
         ),
         new BottomNavyBarItem
         (
           icon: Icon(Icons.account_circle),
           title: Text('Profile')
         )
       ], 
      ),
    );
  }
}