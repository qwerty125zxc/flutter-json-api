import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _fileHeaders async {
  final path = await _localPath;
  return File('$path/data.txt');
}

Future<File> get _filePassword async {
  final path = await _localPath;
  return File('$path/password.txt');
}

Future<File> saveHeaders(String content) async {
  final file = await _fileHeaders;
  return file.writeAsString(content, mode: FileMode.write);
}

Future<File> savePassword(String content) async {
  final file = await _filePassword;
  return file.writeAsString(content, mode: FileMode.write);
}

Future<String> getHeaders() async {
  String contents;
  final file = await _fileHeaders;
  contents = await file.readAsString();
  return contents;
}

Future<String> getPassword() async {
  String contents;
  final file = await _fileHeaders;
  contents = await file.readAsString();
  return contents;
}
