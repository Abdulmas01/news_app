import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:news_app/api/navigation_api.dart';
import 'package:news_app/api/snackbar_api.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/pages/article_comments.dart';
import 'package:news_app/style/box_shadow.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({
    Key? key,
    required this.article,
  }) : super(key: key);
  final Article article;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(article.url))) {
          await launchUrl(Uri.parse(article.url));
        } else {
          SnackbarApi().snackbar(context: context, text: "Fail to open");
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration:
            BoxDecoration(color: Colors.white, boxShadow: containerShadows),
        child: Column(
          children: [
            Text(article.title),
            article.imageUrl == null
                ? Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: const Text("Article has no image"),
                  )
                : CachedNetworkImage(
                    imageUrl: article.imageUrl!,
                    height: 200,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    article.saveLocally();
                    SnackbarApi(duration: const Duration(seconds: 3)).snackbar(
                        text: "Article Saved Succesfully", context: context);
                  },
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: const Icon(Icons.save),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    NavigationApi.nextpage(
                        route: ArticleComments(
                          article: article,
                        ),
                        context: context);
                  },
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: const Icon(Icons.comment),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FlutterShare.share(
                        title: article.title,
                        text: article.content,
                        linkUrl: article.url,
                        chooserTitle: "Share News Article");
                  },
                  child: const Icon(Icons.share),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
