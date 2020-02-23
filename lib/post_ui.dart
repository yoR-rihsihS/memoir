import 'package:flutter/material.dart';
import 'package:memoir/viewblog.dart';
import 'package:progressive_image/progressive_image.dart';


class PostUI
{
  Widget postsUI(String preview, String image, String date, String name, String post, String time, BuildContext context)
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
                image: image == null ? AssetImage("assets/placeholder.jpg") : NetworkImage(image),
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