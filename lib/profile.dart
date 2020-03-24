import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'authentication.dart';
import 'editor.dart';
import 'home_page.dart';
import 'post_ui.dart';
import 'posts.dart';


class ProfilePage extends StatefulWidget 
{
  ProfilePage({
    this.name,
    this.uId,
    this.bio,
    this.auth,
    this.onSignedOut,
  });

  final String bio;
  final String name;
  final String uId;
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> 
{
  List<Posts> postsList = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();

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
  void initState() 
  {
    super.initState();

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

        if(posts.name == widget.name)
        {
          postsList.add(posts);
        }       
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

          if(posts.name == widget.name)
          {
            postsList.add(posts);
          }
        }
        postsList = sortPosts(postsList);
      });
    });

   return null;
  }
  


  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: new AppBar
      (
        title: new Text(widget.name),
      ),

      body: new Column
      (
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>
        [
          new Card
          (
            elevation: 10.0,
            margin: EdgeInsets.only(top:10.0, left:10.0, right:10.0),
            child: new Row
            (
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>
              [
                new Padding
                (
                  padding: EdgeInsets.only
                  (
                    left: 20.0,
                    top: 20.0,
                    right: 20.0,
                    bottom: 20.0,
                  ),
                  child: new CircleAvatar
                  (
                    radius: 60.0,
                    child: new Icon
                    (
                      Icons.person_outline,
                      size: 80.0,
                    ),
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
                new Padding
                (
                  padding: const EdgeInsets.only
                  (
                    left: 20.0,
                    right: 20.0,
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  child: widget.bio == null ? new Text("Bio is empty") : new Text
                  (
                    widget.bio,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
          
          new Center
          (
            child: new Container
             (
              height: 467.0,
              child: new RefreshIndicator
              (
                key: refreshKey,
                onRefresh: refreshList,
                child: postsList.length == 0 ? new Text("No Posts available") : new ListView.builder
                (
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: postsList.length,
                  itemBuilder: (context, index)
                  {
                    return PostUI().postsUI(postsList[index].preview, postsList[index].image, postsList[index].date, postsList[index].name, postsList[index].post, postsList[index].time, context);
                  },
                ),
              ),
            ),
          )
        ],
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
              onPressed: ()
              {
                Navigator.pushReplacement
                (
                  context,
                  MaterialPageRoute(builder: (context)
                  {
                    return HomePage(auth: widget.auth, onSignedOut: widget.onSignedOut,);
                  })
                );
              },
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
                    return EditorPage(name: widget.name,uId: widget.uId,);
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
              onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }
}