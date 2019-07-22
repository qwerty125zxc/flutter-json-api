import 'package:flutter/material.dart';
import 'package:flutter_api/classes/post.dart';
import 'package:flutter_api/ui/posts/views.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
              //TODO: redirect to current user's profile
              Fluttertoast.showToast(msg: 'you pidor');
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
          Navigator.pushNamed(context, 'posts/new');
          }
      ),
    );
  }

  List<Post> parsePhotos(String responseBody) {
    final Map<String, dynamic> jsonResponse = convert.jsonDecode(responseBody);
    return jsonResponse["posts"].map<Post>((json) => Post.fromJson(json)).toList();
  }

  Future<List<Post>> fetchPosts(http.Client client) async {
    final response =
    await client.get('https://milioners.herokuapp.com/api/v1/posts');
    return parsePhotos(response.body);
  }

}