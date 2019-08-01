import 'package:flutter/material.dart';
import 'package:flutter_api/classes/post.dart';
import 'package:flutter_api/classes/user.dart';
import 'package:flutter_api/ui/posts/views.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white70,

      appBar: AppBar(
        title: Text("API App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_box),
            color: Colors.white,
            onPressed: () {
              if (User.signedIn) Navigator.pushNamed(context, 'users/show', arguments: User.current); else
              Navigator.pushNamed(context, 'users/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PostsList(posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text('new post'),
          highlightElevation: 20.0,
          onPressed: () {
            if (User.signedIn) Navigator.pushNamed(context, 'posts/new'); else
              Navigator.pushNamed(context, 'users/login');
          }
      ),
    );
  }

  static List<Post> parsePosts(String responseBody) {
    final Map<String, dynamic> jsonResponse = convert.jsonDecode(responseBody);
    return jsonResponse["posts"].map<Post>((json) => Post.fromJson(json)).toList();
  }

  static Future<List<Post>> fetchPosts(http.Client client) async {
    final response =
    await client.get('https://milioners.herokuapp.com/api/v1/posts');
    return parsePosts(response.body);
  }
}