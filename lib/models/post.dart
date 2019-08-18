import 'package:flutter/material.dart';
import 'package:flutter_api/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'comment.dart';

class Post {
  int id, userId, likesCount, commentsCount;
  String title, body, created, updated;
  dynamic likes;
  List<Comment> comments;

  Future<User> get user async => await User.findById(userId); //does it work fine?

  Post({this.userId: -1, this.id: -1, this.title: "", this.body: "", this.created: "", this.updated: "", this.likesCount, this.likes, this.commentsCount, this.comments});

  factory Post.fromJson(Map<String, dynamic> json) {
    // used in index & show, some fields(through index) are not accessible
    return Post(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      likes: json['likes'],
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      created: json['created_at'] as String,
      updated: json['updated_at'] as String,
    );
  }

  factory Post.fromJsonShow(Map<String, dynamic> json) {
    // used in show
    var list = json['comments'] as List;
    List<Comment> commentsList = list.map((i) => Comment.fromJson(i)).toList();

    return Post(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      likes: json['likes'],
      likesCount: json['likes_count'] as int,
      commentsCount: json['comments_count'] as int,
      comments: commentsList,
      created: json['created_at'] as String,
      updated: json['updated_at'] as String,
    );
  }

  void like() async{
    var response = await http.post('https://milioners.herokuapp.com/api/v1/posts/$id/likes', headers: User.headers);
    debugPrint(response.body);
  }

  bool get liked {
    if (User.signedIn) {
      for (var i in likes) {
        if (i['user_id'] == User.current.id)
          return true;
      }
    }
    return false;
  }

  static Future<Post> findById(int id, created, updated) async {
    var response = await http.get('https://milioners.herokuapp.com/api/v1/posts/$id');
    var post = Post.fromJson(convert.jsonDecode(response.body)['post']);
    post.created = created;
    post.updated = updated;
    return post;
  }
  static Future<Post> findByIdShow(int id, created, updated, int page) async {
    var response = await http.get('https://milioners.herokuapp.com/api/v1/posts/$id?page=$page');
    var post = Post.fromJsonShow(convert.jsonDecode(response.body)['post']);
    post.created = created;
    post.updated = updated;
    return post;
  }
}