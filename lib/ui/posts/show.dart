import 'package:flutter/material.dart';
import 'package:flutter_api/models/post.dart';
import 'package:flutter_api/models/user.dart';
import 'package:flutter_api/ui/posts/views.dart';
import 'package:flutter_api/utils/route_arguments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PostShow extends StatelessWidget {

  Post post;

  _isEdited() => post.created == post.updated ? "" : "\nedited:\t\t\t\t" + post.updated.substring(0,10) + ', ' + post.updated.substring(11,16);

  @override
  Widget build(BuildContext context) {
    RouteArgs args = ModalRoute.of(context).settings.arguments;
    int id = args.id;
    String created = args.created, updated = args.updated;

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
        title: Text(args.title),
      ),
      body: FutureBuilder<Post>(
        future: Post.findById(id, created, updated),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            post = snapshot.data;
            return SingleChildScrollView(
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
                              FlatButton(textTheme: ButtonTextTheme.primary, child: PostView.Nickname(post.userId), onPressed: () async{
                                await Navigator.pushNamed(context, 'users/show', arguments: await User.findById(post.userId));
                              }),
                              Text('created:\t\t' + post.created.substring(0,10) + ', ' + post.created.substring(11,16) + _isEdited()),
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
                          Row(
                            children: <Widget>[
                              Text('Actions:', style: TextStyle(fontStyle: FontStyle.italic),),
                              LikeView(post),
                              Text('[кнопка поширити]', style: TextStyle(fontStyle: FontStyle.italic),),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

}