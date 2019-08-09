import 'package:flutter/material.dart';
import 'package:flutter_api/models/user.dart';
import 'package:flutter_api/models/auth.dart';
import 'dart:convert' as convert;

import 'package:fluttertoast/fluttertoast.dart';

class UserEdit extends StatefulWidget {
  @override
  createState() => UserEditState();
}

class UserEditState extends State<UserEdit> {
  User user;

  static final _formKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  final _nicknameNode = FocusNode();
  final _emailNode = FocusNode();
  final _nameNode = FocusNode();
  final _imageNode = FocusNode();
  final _passwordNode = FocusNode();
  final _currentPasswordNode = FocusNode();

  final _deleteController = TextEditingController();

  confirm(email, image, nickname, name, pass, currPass) async {
    var response = await User.edit(email, image, nickname, name, pass, currPass);
    var body = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Success');
      Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
    }
    else {
      var messages = body["errors"]["full_messages"].toString();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(messages.substring(1, messages.length-1)),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
    }
  }
  void _getPassword() async {
    var creds = await getCredentials();
    _passwordController.text = creds['password'];
  }

  deletePrompt() {
    showDialog(
      context: context,
      builder: (context) {
        _deleteController.text = "";
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Please, enter your password again"),
              TextField(
                controller: _deleteController,
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Next'),
              onPressed: () {
                if (_deleteController.text == _passwordController.text) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("CONFIRM"),
                            onPressed: () async {
                              var response = await User.delete();
                              var body = convert.jsonDecode(response.body);
                              if (response.statusCode == 200) {
                                Fluttertoast.showToast(msg: 'Account was deleted successfully.');
                                Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                              }
                              else {
                                var messages = body["errors"]["full_messages"].toString();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text(messages.substring(1, messages.length-1)),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          ),
                          FlatButton(
                            child: Text("DISCARD"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }
                  );
                }
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;

    _nicknameController.text = user.nickname;
    _nameController.text = user.name;
    _imageController.text = user.image;
    _emailController.text = user.email;
    _getPassword();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          RaisedButton(
            child: Text('Delete account'),
            onPressed: () {
              deletePrompt();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    focusNode: _currentPasswordNode,
                    decoration: InputDecoration(hintText: 'Current password (necessary)'),
                    obscureText: true,
                    controller: _currentPasswordController,
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password length should be >= 6';
                      }
                      return null;
                    },
                  ),
                  Divider(),
                  TextFormField(
                      autofocus: true,
                      focusNode: _nicknameNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: _nicknameController,
                      onFieldSubmitted: (term) {
                        _nicknameNode.unfocus();
                        FocusScope.of(context).requestFocus(_emailNode);
                      },
                      decoration: InputDecoration(hintText: 'nickname'),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Enter some text';
                        }
                        return null;
                      }
                  ),
                  TextFormField(
                    focusNode: _emailNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: _emailController,
                    onFieldSubmitted: (term) {
                      _emailNode.unfocus();
                      FocusScope.of(context).requestFocus(_nameNode);
                    },
                    decoration: InputDecoration(hintText: 'email'),
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Enter some text';
                      }
                      if (!value.contains('@') || !value.contains('.') || value.length < 4) {
                        return "It's not an email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      focusNode: _nameNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: _nameController,
                      onFieldSubmitted: (term) {
                        _nameNode.unfocus();
                        FocusScope.of(context).requestFocus(_imageNode);
                      },
                      decoration: InputDecoration(hintText: 'few words about you'),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Enter some text';
                        }
                        return null;
                      }
                  ),
                  TextFormField(
                      autofocus: true,
                      focusNode: _imageNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: _imageController,
                      onFieldSubmitted: (term) {
                        _imageNode.unfocus();
                        FocusScope.of(context).requestFocus(_passwordNode);
                      },
                      decoration: InputDecoration(hintText: 'Image URL'),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Enter some text';
                        }
                        return null;
                      }
                  ),
                  Divider(),
                  TextFormField(
                    focusNode: _passwordNode,
                    decoration: InputDecoration(hintText: 'New Password'),
                    obscureText: true,
                    enableInteractiveSelection: false,
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _passwordNode.unfocus();
                      FocusScope.of(context).requestFocus(_currentPasswordNode);
                    },
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password length should be >= 6';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          confirm(_emailController.text, _imageController.text, _nicknameController.text, _nameController.text, _passwordController.text, _currentPasswordController.text);
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
