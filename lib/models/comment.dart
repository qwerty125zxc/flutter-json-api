import 'package:flutter_api/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment {
  String text, objectType, created, updated;
  int id, userId, objectId;
  List<Comment> comments;
  int likesCount;
  List<Like> likes;

  Comment({this.text, this.id, this.userId, this.objectId, this.objectType, this.created, this.updated, this.comments, this.likes, this.likesCount});

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

    var comment = Comment.fromJson(json['comment']);
    var comments = json['comments'] as List;
    comment.comments = comments.map((i) => Comment.fromJson(i)).toList();

    var list = json['likes'] as List;
    List<Like> likesList = list.map((i) => Like.fromJson(i)).toList();
    comment.likes = likesList;

    comment.likesCount = json['likes_count'] as int;

    return comment;
  }

  bool get liked {
    if (User.signedIn) {
      for (var i in likes) {
        if (i.userId == User.current.id)
          return true;
      }
    }
    return false;
  }

  like() async {
    return await http.post('https://milioners.herokuapp.com/api/v1/comments/$id/likes', headers: User.headers);
  }

  Future<http.Response> edit(String text) async{
    return await http.put('https://milioners.herokuapp.com/api/v1/comments/$id', headers: User.headers, body:
    jsonEncode(
      { 'text': text }
    ));
  }
  Future<http.Response> delete() async{
    return http.delete('https://milioners.herokuapp.com/api/v1/comments/$id)', headers: User.headers);
  }
}

class Like {
  int id, userId, objectId;
  String objectType;
  Like(this.id, this.userId, this.objectId, this.objectType);

  factory Like.fromJson(Map json) {
    return Like(
      json['id'],
      json['user_id'],
      json['object_id'],
      json['object_type']
    );
  }
}