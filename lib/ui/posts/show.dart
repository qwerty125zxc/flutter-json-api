import 'package:flutter/material.dart';
import 'package:flutter_api/classes/post.dart';

class PostShow extends StatelessWidget {

  Post post;

  _isEdited() => post.created == post.updated ? "" : "\nedited:\t\t\t\t" + post.updated.substring(0,10) + ', ' + post.updated.substring(11,16);

  @override
  Widget build(BuildContext context) {
    post = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  //TODO: handle visibility with Visibility widget & making PostShow a StatefulWidget.
                  RaisedButton(
                    textTheme: ButtonTextTheme.accent,
                    child: Text("EDIT"),
                    onPressed: () {}, //TODO: redirect
                  ),
                  RaisedButton(
                    textTheme: ButtonTextTheme.accent,
                    child: Text("DELETE"),
                    onPressed: () {}, //TODO: do this shit.
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(textTheme: ButtonTextTheme.primary, child: Text(post.userId.toString()), onPressed: () {
                            //TODO: show user nickname; redirect to his posts when onPressed
                          }),
                          Text('created:\t\t' + post.created.substring(0,10) + ', ' + post.created.substring(11,16) + _isEdited()),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(post.title,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            post.body,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}