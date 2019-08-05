import 'package:flutter/material.dart';
import 'package:flutter_api/models/post.dart';
import 'package:flutter_api/models/user.dart';

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
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () {
          Navigator.pushNamed(context, 'posts/show', arguments: post);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(textTheme: ButtonTextTheme.accent, child: Nickname(post.userId), onPressed: () async{
                    await Navigator.pushNamed(context, 'users/show', arguments: await User.findById(post.userId));
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
                  Text(
                    post.body,
                    style: TextStyle(fontSize: 14),
                    maxLines: 4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget Nickname (int id) {
    return FutureBuilder<User>(
      future: User.findById(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(snapshot.data.image, headers: User.headers, height: 32.0,),
              Container(width: 8.0),
              Text(snapshot.data.nickname),
            ],
          );
        } else {
          return Container(width: 0.0, height: 0.0);
        }
      },
    );
  }
}

