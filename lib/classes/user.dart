import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_headers.dart';

class User {
  int id;
  String email;
  //static bool _logAtStartup = false; //TODO: make it a getter & check if files are null

  User(this.id, this.email);

  static User currentUser;
  static bool get signedIn => currentUser == null;
  static Map<String, String> headers;

  static void _saveHeaders(http.Response response) {
    var h = response.headers;
    headers = {
      'Content-Type': 'application/json',
      'access-token': h['access-token'],
      'token-type': h['token-type'],
      'client': h['client'],
      'expiry': h['expiry'],
      'uid': h['uid']
    };
  }

  static void _saveCurrentUser(String responseBody) {
    var body = jsonDecode(responseBody);
    currentUser = new User(
        body['data']['id'],
        body['data']['email']
    );
  }

  static void loginAtStartup(context) async {
      var credentials = await getCredentials();
      http.Response response = await signIn(credentials['email'], credentials['password']);
      if (response.statusCode != 200) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Cannot log in your account. Pkease try again")));
      }
  }

  static Future<http.Response> signUp(email, pass, passConfirm) async {
    var url = 'https://milioners.herokuapp.com/api/v1/auth';
    var response = await http.post(url, body: {
      "email": email,
      "password": pass,
      "password_confirmation": passConfirm
    });
    if (response.statusCode == 200) {
      _saveCurrentUser(response.body);
      _saveHeaders(response);
      saveCredentials(email, pass);
    }
    return response;
  }

  static Future<http.Response> signIn(email, pass) async {
    var url = 'https://milioners.herokuapp.com/api/v1/auth/sign_in';
    var response = await http.post(url, body: {
      "email": email,
      "password": pass,
    });
    if (response.statusCode == 200) {
      _saveCurrentUser(response.body);
      _saveHeaders(response);
      saveCredentials(email, pass);
    }
    return response;
  }
  //findById
}