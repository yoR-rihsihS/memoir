import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:memoir/viewblog.dart';
import 'package:oktoast/oktoast.dart';
import 'authentication.dart';
import 'editor.dart';
import 'posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progressive_image/progressive_image.dart';
import 'profile.dart';
import 'post_ui.dart';

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
          }
        }
      });
    });


    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for(var individualKey in KEYS)
      {
        Posts posts = new Posts
        (
          DATA[individualKey]['preview'],
          DATA[individualKey]['image'],
          DATA[individualKey]['date'], 
          DATA[individualKey]['name'],
          DATA[individualKey]['post'],
          DATA[individualKey]['time'],
          
        );

        postsList.add(posts);
      }
      
      setState(() 
      {
        postsList = sortPosts(postsList);
      });
    });
    
    
  }

  List<Posts> sortPosts(List<Posts> t)
  {
    t.sort((a,b) 
    {
      var adata = a.date + a.time;
      var bdata = b.date + b.time; 
      return bdata.compareTo(adata); 
    });
    return t;
  }

  Future<Null> refreshList() async
  {
    refreshKey.currentState.show();
    await Future.delayed(Duration(seconds: 3));

    setState(() 
    {
      
      DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");

      postsRef.once().then((DataSnapshot snap)
      {
        var KEYS = snap.value.keys;
        var DATA = snap.value;

        postsList.clear();

        for(var individualKey in KEYS)
        {
          Posts posts = new Posts
          (
            DATA[individualKey]['preview'],
            DATA[individualKey]['image'],
            DATA[individualKey]['date'],
            DATA[individualKey]['name'], 
            DATA[individualKey]['post'],
            DATA[individualKey]['time'],
            
          );

          postsList.add(posts);
        }
        postsList = sortPosts(postsList);
      });
    });

   return null;
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
      appBar: new AppBar
      (
        title: new Text("Home Page"),
      ),

      body: new Center
      (
        child: new Container
        (
          child: new RefreshIndicator
          (
            key: refreshKey,
            onRefresh: refreshList,
            child: postsList.length == 0 ? new Text("No Posts available") : new ListView.builder
            (
              itemCount: postsList.length,
              itemBuilder: (context, index)
              {
                return PostUI().postsUI(postsList[index].preview, postsList[index].image, postsList[index].date, postsList[index].name, postsList[index].post, postsList[index].time, context);
              },
            ),
          ),
        ),
      ),
      
      bottomNavigationBar: new BottomAppBar
      (
        color: Colors.lightBlueAccent,
        child: new Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>
          [
            new IconButton
            (
              icon: new Icon(Icons.home),
              onPressed: (){},
            ),
            new IconButton
            (
              icon: new Icon(Icons.add_photo_alternate),
              onPressed: ()
              {
                Navigator.push
                (
                  context,
                  MaterialPageRoute(builder: (context)
                  {
                    return EditorPage(name: name,uId: uid,);
                  })
                );
              },
            ),
            new IconButton
            (
              icon: new Icon(Icons.pets),
              onPressed: _logOutUser,
            ),
            new IconButton
            (
              icon: new Icon(Icons.account_circle),
              onPressed: ()
              {
                Navigator.pushReplacement
                (
                  context,
                  MaterialPageRoute(builder: (context)
                  {
                    return ProfilePage(name: name,uId: uid,auth: widget.auth,onSignedOut: widget.onSignedOut);
                  })
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}