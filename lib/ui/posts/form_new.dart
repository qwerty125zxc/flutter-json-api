import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PostCreateForm extends StatefulWidget {
  @override
  createState() => PostCreateFormState();
}

class PostCreateFormState extends State<PostCreateForm> {
  static final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final _titleNode = FocusNode();
  final _bodyNode = FocusNode();

  PostCreateFormState();

  @override
  Widget build(BuildContext context) {

    submit() async {
      var url = 'https://milioners.herokuapp.com/api/v1/posts';
      var headers = {'Content-Type': 'application/json'};
      try {
        var response = await http.post(url, headers: headers,
            body: convert.jsonEncode({
              "post": {
                "user_id": 1,
                "title": _titleController.text,
                "body": _bodyController.text
              }
            }));
        if (response.statusCode == 201)
          showDialog(context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success!'),
                content: Text('Post was successfully uploaded.'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                    },
                  )
                ],
              );
            },
            barrierDismissible: false,
          );
        else
          showDialog(context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("you failed me"),
                );
              },
          );
      } catch(e) {
        showDialog(context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Please check your Internet connection."),
              );
            }
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("New Post")
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
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    controller: _titleController,
                    onFieldSubmitted: (term) {
                      _titleNode.unfocus();
                      FocusScope.of(context).requestFocus(_bodyNode);
                    },
                    decoration: InputDecoration(hintText: 'title'),
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _bodyNode,
                    decoration: InputDecoration(hintText: 'body'),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    controller: _bodyController,
                    validator: (value) {
                      if (value.trim().isEmpty) {
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
