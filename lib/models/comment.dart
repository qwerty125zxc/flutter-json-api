import 'package:flutter_api/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment {
  String text, objectType, created, updated;
  int id, userId, objectId;
  List<Comment> comments;

  Comment({this.text, this.id, this.userId, this.objectId, this.objectType, this.created, this.updated, this.comments});

  factory Comment.fromJson(Map json) {
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      objectId: json['object_id'],
      objectType: json['object_type'],
      text: json['text'],
      created: json['created_at'],
      updated: json['updated_at']
    );
  }

  static Future<http.Response> create(int objectId, String objectType, String text) async{
    var url = 'https://milioners.herokuapp.com/api/v1/comments';
    var body = jsonEncode({
      'object_id': objectId,
      'object_type': objectType,
      'text': text
    });
    return http.post(url, headers: User.headers, body: body);
  }

  static Future<Comment> findById(int id) async{
    var url = 'https://milioners.herokuapp.com/api/v1/comments/$id';
    var response = await http.get(url);
    var json = jsonDecode(response.body);

    var comment = Comment.fromJson(json);
    var comments = json['comments'] as List;
    comment.comments = comments.map((i) => Comment.fromJson(i)).toList();

    return comment;
  }
}