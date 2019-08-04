import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class User {
  int id;
  String nickname, email, name, image;

  User(this.id, this.nickname, this.email, this.name, this.image);

  static User current;
  static bool get signedIn => current != null;
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
    current = new User(
        body['data']['id'],
        body['data']['nickname'],
        body['data']['email'],
        body['data']['name'],
        body['data']['image']
    );
  }

  static void loginAtStartup(context) async {
      var credentials = await getCredentials();
      var email = credentials['email']; var password = credentials['password'];
      if (email != "" && password != "") {
        http.Response response = await signIn(email, password);
        if (response.statusCode != 200) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Cannot log in your account. Pkease try again")));
        }
      }
  }

  static Future<http.Response> signUp(nickname, email, name, image, pass, passConfirm) async {
    var url = 'https://milioners.herokuapp.com/api/v1/auth';
    var response = await http.post(url, body: {
      "nickname": nickname,
      "email": email,
      "name": name,
      "image": image,
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

  static Future<http.Response> edit(email, image, nickname, name, pass, currentPass) async{
    var url = 'https://milioners.herokuapp.com/api/v1/auth';
    var response = await http.put(url, headers: headers, body: jsonEncode({
      "email": email,
      "password": pass,
      "current_password": currentPass,
      "image": image,
      "nickname": nickname,
      "name": name
    }));
    if (response.statusCode == 200) {
      _saveCurrentUser(response.body);
      _saveHeaders(response);
      saveCredentials(email, pass);
    }
    return response;
  }

  static Future<User> findById (int id) async{
    var url = 'http://milioners.herokuapp.com/api/v1/users/$id';
    var response = await http.get(url);
    var body = jsonDecode(response.body);
    if (body['user'] == null) {
      return User(-1, "", "", "", "");
    }
    else {
      return User(body['user']['id'], body['user']['nickname'], body['user']['email'], body['user']['name'], body['user']['image']);
    }
  }

  static Future<http.Response> logout() async{
    var url = 'https://milioners.herokuapp.com/api/v1/auth/sign_out';
    var logoutHeaders = {
      'access-token': headers['access-token'],
      'token-type': headers['token-type'],
      'client': headers['client'],
      'expiry': headers['expiry'],
      'uid': headers['uid']
    };
    saveCredentials("", "");
    current = null;
    return await http.delete(url, headers: logoutHeaders);
  }
}