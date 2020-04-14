import 'package:flutter/material.dart';
import 'package:memoir/viewblog.dart';
import 'package:progressive_image/progressive_image.dart';


class PostUI
{
  Widget postsUI(String preview, String image, String date, String name, String post, String time, BuildContext context)
  {
    return new Card
    (
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(20.0),
      ),
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
                image: (image == null || image == "") ? AssetImage("assets/noimage.jpg") : NetworkImage(image),
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
                  new Text(name != null ? name : '', style: Theme.of(context).textTheme.subhead, textAlign: TextAlign.center,),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}




class ProfileUI
{
  Widget profileUI(String name, String bio, String propic, BuildContext context)
  {
    return new Card
    (
      shape: RoundedRectangleBorder
      (
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10.0,
      margin: EdgeInsets.only(top:10.0, left:10.0, right:10.0),
      child: new Row
      (
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>
        [
          new Align
          (
            child: new SizedBox
            (
              height: 150,
              width: 150,
              child: new Padding
              (
                padding: EdgeInsets.all(10.0),
                child: new CircleAvatar
                (
                  radius: 21,
                  backgroundColor: Color(0xff292826),
                  child: propic == null ? new Icon(Icons.person, size: 100.0,) : new CircleAvatar(
                    radius: 61,
                    backgroundImage: NetworkImage(propic),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          new Column
          (
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>
            [
              new Padding
              (
                padding: const EdgeInsets.only
                (
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                  bottom: 5.0,
                ),
                child: name == null ? new Text("Name is empty") : new Text
                (
                  name,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.title,
                  maxLines: null,
                ),
              ),
              new Padding
              (
                padding: const EdgeInsets.only
                (
                  left: 20.0,
                  right: 20.0,
                  top: 5.0,
                  bottom: 20.0,
                ),
                child: bio == null ? new Text("Bio is empty", textAlign: TextAlign.left,) : new Text
                (
                  bio,
                  textAlign: TextAlign.left,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}