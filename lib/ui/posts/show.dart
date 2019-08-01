import 'package:flutter/material.dart';
import 'package:flutter_api/classes/post.dart';
import 'package:flutter_api/classes/user.dart';
import 'package:flutter_api/ui/posts/views.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PostShow extends StatelessWidget {

  Post post;

  _isEdited() => post.created == post.updated ? "" : "\nedited:\t\t\t\t" + post.updated.substring(0,10) + ', ' + post.updated.substring(11,16);

  @override
  Widget build(BuildContext context) {
    post = ModalRoute.of(context).settings.arguments;

    delete() async {
      var url = 'https://milioners.herokuapp.com/api/v1/posts/${post.id}';
      try {
        var response = await http.delete(url, headers: User.headers);
        if (response.statusCode == 200)
          showDialog(context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Post was successfully deleted.'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                    },
                  )
                ],
              );
            },
            barrierDismissible: false,
          );
        else
          showDialog(context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(convert.jsonDecode(response.body)['errors'].toString()),
                );
              }
          );
      } catch(e) {
        showDialog(context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Please check your Internet connection."),
              );
            }
        );
      }
    }

    deletePrompt() {
      showDialog(context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          actions: <Widget>[
            FlatButton(
              child: Text("NO"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("YES"),
              onPressed: () => delete(),
            ),
          ],
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Visibility(
                visible: User.signedIn && post.userId == User.current.id,
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      textTheme: ButtonTextTheme.accent,
                      child: Text("EDIT"),
                      onPressed: () => Navigator.pushNamed(context, 'posts/edit', arguments: post)
                    ),
                    RaisedButton(
                      textTheme: ButtonTextTheme.accent,
                      child: Text("DELETE"),
                      onPressed: () => deletePrompt(),
                    ),
                  ],
                ),
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
                          FlatButton(textTheme: ButtonTextTheme.primary, child: PostView.Email(post.userId), onPressed: () {
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