import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'post_ui.dart';
import 'posts.dart';


class PageContent extends StatefulWidget {
  PageContent({this.index,this.auth});

  final int index;
  final AuthImplementation auth;

  @override
  _PageContentState createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  String name = "";
  String bio = "";
  String uid = "";
  AuthImplementation autth = new Auth();
  DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");
  List<Posts> postsList = [];
  List<Posts> postsList2 = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var refreshKey2 = GlobalKey<RefreshIndicatorState>();

  void getPost(var KEYS, var DATA)
  {
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
  }

  void getPost2(var KEYS, var DATA)
  {
    postsList2.clear();

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
      if(posts.name == name)
      {
        postsList2.add(posts);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    
    autth.getCurrentUser().then((firebaseUserID)
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
    

    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      getPost(KEYS,DATA);
      getPost2(KEYS,DATA);
      
      setState(() 
      {
        postsList = sortPosts(postsList);
        postsList2 = sortPosts(postsList2);
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
      postsRef.once().then((DataSnapshot snap)
      {
        var KEYS = snap.value.keys;
        var DATA = snap.value;

        getPost(KEYS, DATA);

        postsList = sortPosts(postsList);
      });
    });
   return null;
  }

  Future<Null> refreshList2() async
  {
    refreshKey2.currentState.show();
    await Future.delayed(Duration(seconds: 3));

    setState(() 
    {
      postsRef.once().then((DataSnapshot snap)
      {
        var KEYS = snap.value.keys;
        var DATA = snap.value;

        getPost2(KEYS, DATA);

        postsList2 = sortPosts(postsList2);
      });
    });
   return null;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.index == 1)
    {
      return new Center
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
      );
    }

    else if(widget.index == 3)
    {
      
    
      return new Column
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
                  padding: EdgeInsets.all(20.0),
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
                  child: bio == null ? new Text("Bio is empty") : new Text
                  (
                    bio,
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
              height: 465.7,
              child: new RefreshIndicator
              (
                key: refreshKey2,
                onRefresh: refreshList2,
                child: postsList2.length == 0 ? new Text("No Posts available") : new ListView.builder
                (
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: postsList2.length,
                  itemBuilder: (context, index)
                  {
                    return PostUI().postsUI(postsList2[index].preview, postsList2[index].image, postsList2[index].date, postsList2[index].name, postsList2[index].post, postsList2[index].time, context);
                  },
                ),
              ),
            ),
          )
        ],
      ); 
    }

    else
    {
      return new Spacer();
    }
  }
}