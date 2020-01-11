import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memoir/viewblog.dart';
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
            new Padding(padding: EdgeInsets.only(left: 8.0),),
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
                return postsUI(postsList[index].preview, postsList[index].image, postsList[index].date, postsList[index].name, postsList[index].post, postsList[index].time);
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
                    return EditorPage(name: name,uId: uid,);
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


  Widget postsUI(String preview, String image, String date, String name, String post, String time)
  {
    return new Card
    (
      elevation: 10.0,
      margin: EdgeInsets.all(10.0),
      child: new InkWell
      (
        onTap: ()
        {
          Navigator.push
          (
            context,
            MaterialPageRoute(builder: (context)
            {
              return ViewPage(doc: post,);
            })
          );
        },
        child: new Padding
        (
          padding: EdgeInsets.all(10.0),
          child: new Column
          (
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              new ProgressiveImage
              (
                placeholder: AssetImage("assets/placeholder.jpg"),
                thumbnail: AssetImage("assets/placeholder.jpg"),
                image: NetworkImage(image),
                blur: 10,
                width: 400,
                height: 400,
                fit: BoxFit.contain,
              ),
              new Padding(padding: EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0)),
              new Row
              (
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>
                [
                  new Expanded
                  (
                    child: new RichText
                    (
                      text: TextSpan
                      (
                        text: preview,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      textAlign: TextAlign.start, 
                      maxLines: null,
                    ),
                  ),
                ],
              ),
              new Row
              (
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>
                [
                  new Text(name!=null?name:'', style: Theme.of(context).textTheme.subhead, textAlign: TextAlign.center,),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}