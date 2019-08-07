import 'package:flutter/material.dart';
import 'package:flutter_api/models/user.dart';
import 'package:flutter_api/ui/posts/views.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserPage extends StatelessWidget {
  User user;

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments; //id

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
            IconButton(
              tooltip: 'Edit profile',
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, 'users/edit', arguments: user);
              },
            ),
            IconButton(
              tooltip: 'Log out',
              icon: Icon(Icons.exit_to_app),
              onPressed: () => logoutPrompt(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                child: ClipOval(child: Image.network(user.image, fit: BoxFit.cover)),
              ),
              SizedBox(width: 8),
              Text(user.nickname),
            ],
          ),
          actions: <Widget>[
            buttons()
          ],
        ),
        body:
          PaginatedPosts.startWith(_buildMainLayout(), 'http://milioners.herokuapp.com/api/v1/users/${user.id}', hideAuthor: true)
    );
  }

  List<Widget> _buildMainLayout() {
    return [
      Container(
        color: Colors.white,
        child: ListTile(
          title: Text("About"),
          subtitle: Text(user.name),
        ),
      ),
      Divider(),
      Container(
        color: Colors.white,
        child: ListTile(
          title: Text("Posts:"),
        ),
      )
    ];
  }
}