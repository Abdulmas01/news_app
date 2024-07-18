import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';

class ArticleDetails extends StatefulWidget {
  const ArticleDetails({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
