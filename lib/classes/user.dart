import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'auth_headers.dart';

class User {
  int id;
  String email;

  User(this.id, this.email);

  static User currentUser;
  static bool get signedIn => currentUser == null;
  static var headers;

  static void _saveUser(http.Response response, String password) {
    var h = response.headers;
    headers = {
      'Content-Type': 'application/json',
      'access-token': h['access-token'],
      'token-type': h['token-type'],
      'client': h['client'],
      'expiry': h['expiry'],
      'uid': h['uid']
    };

    currentUser = new User(
        jsonDecode(response.body)['data']['id'],
        jsonDecode(response.body)['data']['email']
    );

    saveHeaders(jsonEncode(headers));
    savePassword(password);
  }

  static void loginAtStartup() async {
    var h = await getHeaders();
    headers = jsonDecode(h);
    var pass = await getPassword();
    http.Response response = await signIn(headers['uid'], pass);
    if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "Cannot log in to your account");
    }
  }

  static Future<http.Response> signUp(email, pass, passConfirm) async {
    var url = 'https://milioners.herokuapp.com/api/v1/auth';
    var response = await http.post(url, body: {
      "email": email,
      "password": pass,
      "password_confirmation": passConfirm
    });
    _saveUser(response, pass);
    return response;
  }

  static Future<http.Response> signIn(email, pass) async {
    var url = 'https://milioners.herokuapp.com/api/v1/auth/sign_in';
    var response = await http.post(url, body: {
      "email": email,
      "password": pass,
    });
    _saveUser(response, pass);
    return response;
  }
  //findById
}