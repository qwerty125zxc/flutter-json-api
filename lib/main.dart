import 'package:flutter/material.dart';
import 'package:flutter_api/ui/homepage.dart';
import 'package:flutter_api/ui/posts/form.dart';

void main() => runApp(APIApp());

class APIApp extends StatelessWidget {
  // This widget is the root of your application.
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
      },
    );
  }
}

