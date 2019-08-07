import 'package:flutter/material.dart';
import 'package:flutter_api/models/post.dart';
import 'package:flutter_api/models/user.dart';
import 'package:flutter_api/ui/posts/views.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  createState() => HomePageState();
}
class HomePageState extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;
  var client = http.Client();
  List posts = new List();
  int _pageCounter = 1;

  @override
  void initState() {
    _getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      body: Container(
        child: _buildList(),
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
      resizeToAvoidBottomPadding: false,
    );
  }

  static List<Post> parsePosts(String responseBody) {
    final Map<String, dynamic> jsonResponse = convert.jsonDecode(responseBody);
    return jsonResponse["posts"].map<Post>((json) => Post.fromJson(json)).toList();
  }

  static Future<List<Post>> fetchPosts(http.Client client, String url, int page) async {
    var request = '$url?page=$page';
    final response = await client.get(request);
    return parsePosts(response.body);
  }

  void _getMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var psts = await fetchPosts(client, 'https://milioners.herokuapp.com/api/v1/posts', _pageCounter++);

      setState(() {
        isLoading = false;
        posts.addAll(psts);
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      //+1 for progressbar
      itemCount: posts.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == posts.length) {
          return _buildProgressIndicator();
        } else {
          return PostView(posts[index]);
        }
      },
      controller: _scrollController,
    );
  }

}