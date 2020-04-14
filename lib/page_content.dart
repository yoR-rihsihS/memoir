import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'post_ui.dart';
import 'posts.dart';


class PageContent extends StatefulWidget {
  PageContent({this.index});

  final int index;

  @override
  _PageContentState createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  String name;
  String bio;
  String uid;
  String propic;
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
        DATA[individualKey]['uId'],
      );
      postsList.add(posts);
      if(posts.uid == uid)
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
      uid = firebaseUserID;
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
            propic = DATA[individualKey]['propic'];
          }
        }
      });
    });
    

    postsRef.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      getPost(KEYS,DATA);
      
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

        getPost(KEYS, DATA);

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
      return new Container
        (
          child: new RefreshIndicator
          (
            key: refreshKey2,
            onRefresh: refreshList2,
            child: new ListView.builder
            (
              itemCount: postsList2.length+1,
              itemBuilder: (context, index)
              {
                return (index == 0)
                ? ProfileUI().profileUI(name, bio, propic, context)
                : PostUI().postsUI(postsList2[index-1].preview, postsList2[index-1].image, postsList2[index-1].date, postsList2[index-1].name, postsList2[index-1].post, postsList2[index-1].time, context);
              },
            ),
          ),
        );
    }



    else
    {
      return new Spacer();
    }
  }
}