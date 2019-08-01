import 'package:flutter/material.dart';
import 'package:flutter_api/classes/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    logout() async{
      var response = await User.logout();
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Logged out successfully.');
        Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
      }
      else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('<Please check yout Internet connection>\n${response.statusCode}; ${response.body}'),
            );
          }
        );
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
        }
      );
    }
    
    return Scaffold(
        appBar: AppBar(
          title: Text(User.current.email),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  textTheme: ButtonTextTheme.accent,
                  child: Text("EDIT PROFILE"),
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
          ]),
        )));
  }
}
