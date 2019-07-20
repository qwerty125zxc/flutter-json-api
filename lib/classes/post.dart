class Post {
  int id, user_id;
  String title, body, created, updated='';

  Post({this.user_id: -1, this.id: -1, this.title: "", this.body: "", this.created: "", this.updated: ""});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      user_id: json['user_id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      created: json['created_at'] as String,
      updated: json['updated_at'] as String,
    );
  }
}