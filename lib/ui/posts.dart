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
              children: <Widget>[
                FlatButton(child: Text(post.user_id.toString()), onPressed: () {
                  //TODO: show user nickname; redirect to his posts when onPressed
                }),
              ],
            ),
            Row(
              children: <Widget>[
                Text(post.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(width: 200),
                Text(post.created)
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
