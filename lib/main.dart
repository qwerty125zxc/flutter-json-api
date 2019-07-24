import 'package:flutter/material.dart';
import 'package:flutter_api/ui/homepage.dart';
import 'package:flutter_api/ui/posts/form_edit.dart';
import 'package:flutter_api/ui/posts/form_new.dart';
import 'package:flutter_api/ui/posts/show.dart';

void main() => runApp(APIApp());

class APIApp extends StatelessWidget {

  //TODO: static User currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        'posts/new': (context) => PostCreateForm(),
        'posts/show': (context) => PostShow(),
        'posts/edit': (context) => PostEditForm(),
      },
    );
  }
}

