class Post {
  int id, userId;
  String title, body, created, updated;

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

  static Post findById(int id)
  {
    //return Post.fromJson(json)
    //'https://milioners.herokuapp.com/api/v1/posts/${post.id}'
  }
}