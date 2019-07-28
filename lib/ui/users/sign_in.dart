import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  createState() => SignInState();
}

class SignInState extends State<SignIn> {
  static final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();

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
                focusNode: _emailNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: _emailController,
                onFieldSubmitted: (term) {
                  _emailNode.unfocus();
                  FocusScope.of(context).requestFocus(_passwordNode);
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
                focusNode: _passwordNode,
                decoration: InputDecoration(hintText: 'password'),
                obscureText: true,
                controller: _passwordController,
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