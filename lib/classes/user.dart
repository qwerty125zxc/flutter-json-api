import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  int id;
  String email;

  User(this.id, this.email);

  static User currentUser;
  static var headers;

  static Future<http.Response> signUp(email, pass, passConfirm) async {
    var url = 'https://milioners.herokuapp.com/api/v1/auth';
    var response = await http.post(url, body: {
      "email": email,
      "password": pass,
      "password_confirmation": passConfirm
    });
    headers = response.headers;

    currentUser = new User(
        jsonDecode(response.body)['data']['id'],
        jsonDecode(response.body)['data']['email']
    );
    return response;
  }
}