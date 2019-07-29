import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> saveHeaders(String content) async {
    final file = await _localFile;
    return file.writeAsString(content, mode: FileMode.write);
  }

  Future<Map<String, dynamic>> getHeaders() async {
    String contents;
    final file = await _localFile;
    contents = await file.readAsString();
    return jsonDecode(contents);
  }
