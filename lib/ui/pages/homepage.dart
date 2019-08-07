import 'package:flutter/material.dart';
import 'package:flutter_api/models/user.dart';
import 'package:flutter_api/ui/posts/views.dart';

class HomePage extends StatefulWidget {
  @override
  createState() => HomePageState();
}
class HomePageState extends State<HomePage> {

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
        child: PaginatedPosts('https://milioners.herokuapp.com/api/v1/posts'),
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

}