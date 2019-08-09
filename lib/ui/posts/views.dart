import 'package:flutter/material.dart';
import 'package:flutter_api/models/post.dart';
import 'package:flutter_api/models/user.dart';
import 'package:flutter_api/utils/route_arguments.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PaginatedPosts extends StatefulWidget {
  final String url;
  List<Widget> widgets;
  bool hideAuthor;

  PaginatedPosts(this.url, {this.hideAuthor});
  PaginatedPosts.startWith(this.widgets, this.url, {this.hideAuthor});

  @override
  createState() => PaginatedPostsState(url, startWith: widgets, hideAuthor: hideAuthor);
}
class PaginatedPostsState extends State<PaginatedPosts> {
  String url;
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;
  var client = http.Client();
  List posts = new List();
  int _pageCounter = 1;
  bool hideAuthor;

  PaginatedPostsState(this.url, {List<Widget> startWith, this.hideAuthor: false}) {
    if (startWith != null)
      posts.insertAll(0, startWith);
  }

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
  Widget build(BuildContext context) => _buildList();

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

      var psts = await fetchPosts(client, url, _pageCounter++);

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
          return posts[index] is Post? PostView(posts[index], hideAuthor: hideAuthor) : posts[index];
        }
      },
      controller: _scrollController,
    );
  }
}

class PostView extends StatelessWidget {
  final Post post;
  bool hideAuthor;

  PostView(this.post, {this.hideAuthor = false}) {
    if (hideAuthor == null) hideAuthor = false;
  }

  _isEdited() => post.created == post.updated ? "" : " (edited)";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () {
          Navigator.pushNamed(context, 'posts/show', arguments: RouteArgs(post.id, post.title, post.created, post.updated));
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
                  Visibility(
                    visible: !hideAuthor,
                    child: FlatButton(textTheme: ButtonTextTheme.accent, child: Nickname(post.userId), onPressed: () async{
                      await Navigator.pushNamed(context, 'users/show', arguments: await User.findById(post.userId));
                    }),
                  ),
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
              CircleAvatar(
                radius: 16.0,
                child: ClipOval(child: Image.network(snapshot.data.image, headers: User.headers)),
              ),
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

class LikeView extends StatefulWidget {
  final Post post;

  LikeView(this.post);

  @override
  State<StatefulWidget> createState() => LikeViewState(post);
}
class LikeViewState extends State<LikeView> {
  Post post;
  bool liked = false;
  int count = 0;

  bool loaded;

  LikeViewState(this.post);

  @override
  void initState() {
    liked = post.liked;
    count = post.likesCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: liked? Colors.blue : Colors.grey
            ),
            Text(count.toString()),
          ],
        ),
      ),
      onPressed: () {
        if (User.signedIn) {
          post.like();
          setState(() {
            if (liked) {
              count--;
            }
            else {
              count++;
            }
            liked = !liked;
          });
        }
        else {
          Fluttertoast.showToast(msg: "You need to log in to do this");
        }
      },
    );
  }

}

