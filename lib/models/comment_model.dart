import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/user_model.dart';

class Comment {
  final int id;
  final User user;
  final String articleId;
  final String content;
  final Timestamp time;

  Comment(
      {required this.id,
      required this.articleId,
      required this.content,
      required this.user,
      required this.time});

  factory Comment.fromjson(Map<String, dynamic> json) => Comment(
      id: json['id'],
      user: User.fromJson(json),
      articleId: json['articleId'],
      content: json['content'],
      time: json['time']);

  factory Comment.fromArticle(
      {required Article article, required String comment}) {
    return Comment(
        id: Random().nextInt(1000000),
        articleId: article.id,
        content: comment,
        user: User(username: StorageApi.getUsername()),
        time: Timestamp.now());
  }
  Map<String, dynamic> tojson() {
    return {
      "id": id,
      "username": user.username,
      "articleId": articleId,
      "content": content,
      "time": time
    };
  }
}
