import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  int id;
  String email;

  User(this.id, this.email);

  static User currentUser;
  static var headers;

  static void _saveUser(http.Response response) {
    var h = response.headers;
    headers = {
      'Content-Type': 'application/json',
      'access-token': h['access-token'],
      'token-type': h['token-type'],
      'client': h['client'],
      'expiry': h['expiry'],
      'uid': h['uid']
    };
    print(jsonEncode(headers));

    currentUser = new User(
        jsonDecode(response.body)['data']['id'],
        jsonDecode(response.body)['data']['email']
    );
  }

  static Future<http.Response> signUp(email, pass, passConfirm) async {
    var url = 'https://milioners.herokuapp.com/api/v1/auth';
    var response = await http.post(url, body: {
      "email": email,
      "password": pass,
      "password_confirmation": passConfirm
    });
    _saveUser(response);
    return response;
  }

  static Future<http.Response> signIn(email, pass) async {
    var url = 'https://milioners.herokuapp.com/api/v1/auth/sign_in';
    var response = await http.post(url, body: {
      "email": email,
      "password": pass,
    });
    _saveUser(response);
    return response;
  }
  //findById
}