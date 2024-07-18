// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/async_data_fetch_api.dart';
import 'package:news_app/api/snackbar_api.dart';
import 'package:news_app/extention/scroll_ext.dart';
import 'package:news_app/main.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/comment_model.dart';
import 'package:news_app/utils/database_collection.dart';
import 'package:news_app/widget/async_data_builder.dart';
import 'package:news_app/widget/comment_widget.dart';
import 'package:news_app/enum/data_fetch_enum.dart';

class ArticleComments extends StatefulWidget {
  const ArticleComments({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  int totalComment = 0;
  Stream<QuerySnapshot<Map<String, dynamic>>>? commentStream;
  final ScrollController scrollController = ScrollController();
  AsyncDataFetch<Comment> snapshot = AsyncDataFetch();
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  void getTotalComment() async {
    AggregateQuerySnapshot? docsnapshot = await db
        ?.collection(commentCollection)
        .where("articleId", isEqualTo: widget.article.id)
        .count()
        .get();
    totalComment = docsnapshot?.count ?? 0;
  }

  @override
  void initState() {
    getTotalComment();
    widget.article.getComment().then((value) {
      snapshot.data.addAll(value);
      snapshot.fetchState = FetchState.hasdata;
      setState(() {});
      if (value.isEmpty) {
        snapshot.hasMoreData = false;
      }
    });
    commentStream = widget.article.getCommentStream();
    commentStream?.listen((event) {
      if (snapshot.firstFeach) {
        snapshot.firstFeach = false;
        return;
      }
      List<Comment> fetchedComent =
          event.docs.map((e) => Comment.fromjson(e.data())).toList();
      for (final element in snapshot.data) {
        fetchedComent
            .removeWhere((newcomment) => element.content == newcomment.content);
      }

      snapshot.data.addAll(fetchedComent);
      getTotalComment();
    });

    scrollController.addListener(() async {
      if (scrollController.isEndOfList && snapshot.hasMoreData) {
        List<Comment> newData = await widget.article.getComment();
        snapshot.data.addAll(newData);
        if (newData.isEmpty) {
          snapshot.hasMoreData = false;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: size.height,
                width: size.width,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(widget.article.title),
                    ),
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(9),
                              topRight: Radius.circular(9))),
                      child: Column(
                        children: [
                          Text("${totalComment.toString()} Comments"),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                              height: 3,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: AsyncDataBuilder(
                                scrollController: scrollController,
                                data: snapshot.data,
                                snapshot: snapshot,
                                size: size,
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) =>
                                      CommentWidget(
                                          comment: snapshot.data.reversed
                                              .toList()[index]),
                                )),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: commentFocus,
                          controller: commentController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: "Add Comment",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        color: Colors.green,
                        child: IconButton(
                            onPressed: () async {
                              if (commentController.text.isEmpty) {
                                SnackbarApi().snackbar(
                                    context: context,
                                    text: "Comment Cannot Be Empty");
                                return;
                              }
                              if (commentFocus.hasFocus) {
                                commentFocus.unfocus();
                              }
                              Comment userComment = Comment.fromArticle(
                                  article: widget.article,
                                  comment: commentController.text);
                              await widget.article.comment(userComment);
                              commentController.text = "";
                              totalComment += 1;
                              setState(() {});
                              SnackbarApi().snackbar(
                                  context: context, text: "Comment Uploaded");
                            },
                            icon: const Icon(Icons.send)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
