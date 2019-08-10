import 'package:flutter_api/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment {
  String text;
  int id, userId, postId;

  Comment(this.text, this.id, this.userId, this.postId);

  factory Comment.fromJson(Map json) {
    return null;
    //TODO: finish
  }

  static Future<http.Response> create(int objectId, String objectType, String text) async{
    var url = 'https://milioners.herokuapp.com/api/v1/comments';
    var body = jsonEncode({
      'object_id': objectId,
      'object_type': objectType,
    });
    return http.post(url, headers: User.headers, body: body);
  }
}