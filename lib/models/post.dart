import 'package:flutter/material.dart';
import 'package:flutter_api/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Post {
  int id, userId;
  String title, body, created, updated;
  int get likes => 0;
  Future<User> get user async => await User.findById(userId); //does it work fine?

  Post({this.userId: -1, this.id: -1, this.title: "", this.body: "", this.created: "", this.updated: ""});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      created: json['created_at'] as String,
      updated: json['updated_at'] as String,
    );
  }

  static Future<Post> findById(int id) async
  {
    var response = await http.get('https://milioners.herokuapp.com/api/v1/posts/$id');
    debugPrint(convert.jsonEncode(response.body));
    return Post.fromJson(convert.jsonDecode(response.body));
  }
}