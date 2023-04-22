import 'package:flutter/material.dart';
import 'package:postvibs/sqllite/dataHelper.dart';
import 'package:postvibs/sqllite/sqlModel.dart';

class VideoProvider extends ChangeNotifier {
  List<SqlModel> _list = [];

  List<SqlModel> get list => _list;

  void init() async {
    final videoList = await SqliteHelper().getAll();
    _list = videoList;
    notifyListeners();
  }

  List<SqlModel> search(String keyword) {
    // Search for videos that match the keyword
    List<SqlModel> results = [];
    for (var video in _list) {
      if (video.title.contains(keyword) ||
          video.description.contains(keyword) ||
          video.category.contains(keyword)) {
        results.add(video);
      }
    }
    return results;
  }

  void add(SqlModel video) {
    // Add a new video to the list
    _list.add(video);
    notifyListeners();
  }
}
