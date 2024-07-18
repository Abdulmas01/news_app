import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/models/comment_model.dart';
import 'package:news_app/style/text_style.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  final Comment comment;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 212, 223, 224),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                comment.user.username.capitalizeFirst!,
                style: sectionHeader2Style,
              ))
            ],
          ),
          Container(
              padding: const EdgeInsets.only(left: 50),
              child: Text(comment.content))
        ],
      ),
    );
  }
}
