import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _file async {
  final path = await _localPath;
  return File('$path/credentials.txt');
}

Future<File> saveCredentials(String email, String password) async {
  final file = await _file;
  return file.writeAsString('$email $password', mode: FileMode.write, encoding: utf8);
}

Future<Map<String, String>> getCredentials() async {
  String contents;
  final file = await _file;
  contents = await file.readAsString(encoding: utf8);
  print(contents);
  var list = contents.split(" ");
  return {'email': list[0], 'password': list[1]};
}

