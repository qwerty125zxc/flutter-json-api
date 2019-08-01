import 'package:flutter/material.dart';
import 'package:flutter_api/classes/post.dart';
import 'package:flutter_api/classes/user.dart';
import 'package:flutter_api/ui/pages/homepage.dart';
import 'package:flutter_api/ui/posts/views.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatelessWidget {
  User user;

  @override
  Widget build(BuildContext context) {
    user = ModalRoute
        .of(context)
        .settings
        .arguments; //id

    logout() async {
      var response = await User.logout();
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Logged out successfully.');
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                    'Please check yout Internet connection'),
              );
            });
      }
    }

    logoutPrompt() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Really log out?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('YES'),
                  onPressed: () => logout(),
                ),
                FlatButton(
                  child: Text('NO'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
    }

    Widget buttons() {
      return Visibility(
        visible: User.signedIn && user.id == User.current.id,
        child: Row(
          children: <Widget>[
            RaisedButton(
              textTheme: ButtonTextTheme.accent,
              child: Text("PROFILE"),
              onPressed: () {
                //TODO: implement method
              },
            ),
            RaisedButton(
              textTheme: ButtonTextTheme.accent,
              child: Text("LOG OUT"),
              onPressed: () => logoutPrompt(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(user.email),
          actions: <Widget>[
            buttons()
          ],
        ),
        body:
        FutureBuilder<List<Post>>(
          future: HomePage.fetchPosts(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
               ? PostsList(posts: snapshot.data.where((post) => post.userId == user.id).toList())
                : Center(child: CircularProgressIndicator());
          },
        )
    );
  }
}
