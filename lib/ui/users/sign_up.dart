import 'package:flutter/material.dart';
import 'package:flutter_api/models/user.dart';
import 'dart:convert' as convert;

class SignUp extends StatefulWidget {
  @override
  createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  static final _formKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  final _nicknameNode = FocusNode();
  final _emailNode = FocusNode();
  final _nameNode = FocusNode();
  final _imageNode = FocusNode();
  final _passwordNode = FocusNode();
  final _passwordConfirmationNode = FocusNode();

  confirm(nickname, email, name, image, pass, passConfirm) async {
    var response = await User.signUp(nickname, email, name, image, pass, passConfirm);
    var body = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false),
              )
            ],
          );
        },
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                      decoration: InputDecoration(hintText: 'image url'),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Enter some text';
                        }
                        return null;
                      }
                  ),
                  TextFormField(
                    focusNode: _passwordNode,
                    decoration: InputDecoration(hintText: 'password'),
                    obscureText: true,
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _passwordNode.unfocus();
                      FocusScope.of(context).requestFocus(_passwordConfirmationNode);
                    },
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password length should be >= 6';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _passwordConfirmationNode,
                    decoration: InputDecoration(hintText: 'confirm password'),
                    obscureText: true,
                    controller: _passwordConfirmationController,
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password length should be >= 6';
                      }
                      if (value != _passwordController.text) {
                        return "Not equal";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          confirm(_nicknameController.text, _emailController.text, _nameController.text, _imageController.text, _passwordController.text, _passwordConfirmationController.text);
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
