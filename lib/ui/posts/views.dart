import 'package:flutter/material.dart';
import 'package:flutter_api/classes/post.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;

  PostsList({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostView(posts[index]);
      },
    );
  }
}

class PostView extends StatelessWidget {
  final Post post;

  PostView(this.post, {Key key}) : super(key: key);

  _isEdited() => post.created == post.updated ? "" : " (edited)";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(textTheme: ButtonTextTheme.accent, child: Text(post.userId.toString()), onPressed: () {
                  //TODO: show user nickname; redirect to his posts when onPressed
                }),
                Text(post.created.substring(0,10) + '\n' + post.created.substring(11,16) + _isEdited()),
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
                Text(post.body, style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
