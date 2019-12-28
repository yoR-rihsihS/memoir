import 'dart:async';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'photo_upload.dart';
import 'posts.dart';
import 'package:firebase_database/firebase_database.dart';

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
          DATA[individualKey]['date'],
          DATA[individualKey]['description'], 
          DATA[individualKey]['image'],
          DATA[individualKey]['time'],
          DATA[individualKey]['name'],
        );

        postsList.add(posts);
      }
      postsList = sortPosts(postsList);
      setState(() 
      {
        print("No of Posts = $postsList.length");
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
    await Future.delayed(Duration(seconds: 2));

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
            
            DATA[individualKey]['date'],
            DATA[individualKey]['description'], 
            DATA[individualKey]['image'],
            DATA[individualKey]['time'],
            DATA[individualKey]['name'],
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
      print("Error ="+ e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: new AppBar
      (
        title: new Row
        (
          children: <Widget>
          [
            new Icon(Icons.add_a_photo),
            new Text("Home Page"),
          ],
        ),
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
                return postsUI(postsList[index].date, postsList[index].description, postsList[index].image, postsList[index].time, postsList[index].name);
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
              icon: new Icon(Icons.add_photo_alternate),
              onPressed: ()
              {
                Navigator.push
                (
                  context,
                  MaterialPageRoute(builder: (context)
                  {
                    return UploadPhoto(name: name,);
                  })
                );
              },
            ),
            new IconButton
            (
              icon: new Icon(Icons.account_circle),
              onPressed: _logOutUser,
            ),
          ],
        ),
      ),
    );
  }


  Widget postsUI(String date, String description, String image, String time, String name)
  {
    return new Card
    (
      elevation: 10.0,
      margin: EdgeInsets.all(10.0),
      child: new Padding
      (
        padding: EdgeInsets.all(10.0),
        child: new Column
      (
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>
        [
          new Row
          (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>
            [
              new Text(time, style: Theme.of(context).textTheme.subtitle),
              new Text(date, style: Theme.of(context).textTheme.subtitle),
            ],
          ),
          new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0)),
          new Image.network(image, fit: BoxFit.fill),
          new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0)),
          new Row
          (
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>
            [
              new Text(name!=null?name:'', style: Theme.of(context).textTheme.subhead, textAlign: TextAlign.center,),
              new Padding(padding: EdgeInsets.only(left: 10.0),),
              new Text(description, style: Theme.of(context).textTheme.caption, textAlign: TextAlign.center,)
            ],
          ),
        ],
      ),
      )
    );
  }
}