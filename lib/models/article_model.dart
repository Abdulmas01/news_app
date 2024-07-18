import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/enum/upload_enum.dart';
import 'package:news_app/main.dart';
import 'package:news_app/models/comment_model.dart';
import 'package:news_app/utils/database_collection.dart';

class Article {
  final String id;
  final String title;
  final String? imageUrl;
  final String url;
  final String content;
  final String source;
  final String publishedAt;

  Article(
      {required this.title,
      required this.id,
      required this.imageUrl,
      required this.content,
      required this.url,
      required this.publishedAt,
      required this.source});

  factory Article.fromJson(Map<String, dynamic> json) {
    String title = (json["title"] as String);
    return Article(
        id: json['author'].toString() +
            (json["title"] as String)
                .substring(0, title.length > 10 ? 10 : title.length),
        publishedAt: json['publishedAt'],
        title: json['title'],
        imageUrl: json['urlToImage'],
        url: json['url'],
        content: json['content'],
        source: json['source']["name"]);
  }

  Future<List<Comment>> getComment() async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await db!
          .collection(commentCollection)
          .where('articleId', isEqualTo: id)
          .orderBy("time", descending: true)
          .limit(10)
          .get();
      return data.docs
          .map((comment) => Comment.fromjson(comment.data()))
          .toList();
    } on Exception {
      return [];
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getCommentStream() {
    return db
        ?.collection(commentCollection)
        .where("articleId", isEqualTo: id)
        .limit(10)
        .orderBy("time", descending: true)
        .snapshots()
        .asBroadcastStream();
  }

  Future<UploadState> comment(Comment comment) async {
    try {
      await db?.collection(commentCollection).add(comment.tojson());
      return UploadState.uploaded;
    } on Exception {
      return UploadState.failed;
    }
  }

  void saveLocally() {
    StorageApi.addArticle(this);
  }

  Map toJson() {
    return {
      "title": title,
      "content": content,
      "urlToImage": imageUrl,
      "publishedAt": publishedAt,
      "url": url,
      "source": {"name": source}
    };
  }
}
