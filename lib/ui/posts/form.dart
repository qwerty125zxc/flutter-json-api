import 'package:flutter/material.dart';
import 'package:flutter_api/classes/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PostForm extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  final Post post;

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  PostForm([this.post]);

  @override
  Widget build(BuildContext context) {

    var _titleNode = FocusNode();
    var _bodyNode = FocusNode();

    submit() async {
      var url = 'https://milioners.herokuapp.com/api/v1/posts';
      var headers = {'Content-Type': 'application/json'};
      var response = await http.post(url, headers: headers, body: convert.jsonEncode({"post": {"user_id": 1, "title": _titleController.text, "body": _bodyController.text}}));
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      if (response.statusCode == 201) showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success!'),
            content: Text('Post was successfully uploaded.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
        barrierDismissible: false,
      );
      else showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("you failed me"),
          );
        }
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            post == null ? "New Post" : post.title,
        )
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    focusNode: _titleNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _titleController,
                    onFieldSubmitted: (term) {
                      _titleNode.unfocus();
                      FocusScope.of(context).requestFocus(_bodyNode);
                    },
                    decoration: InputDecoration(hintText: 'title'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _bodyNode,
                    decoration: InputDecoration(hintText: 'body'),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _bodyController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          submit();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
