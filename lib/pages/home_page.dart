import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:news_app/enum/data_fetch_enum.dart';
import 'package:news_app/api/fetch_api.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/article_request_model.dart';
import 'package:news_app/models/preferences.dart';
import 'package:news_app/models/request_model.dart';
import 'package:news_app/style/colors.dart';
import 'package:news_app/utils/all_categories.dart';
import 'package:news_app/widget/article_container.dart';
import 'package:news_app/widget/async_data_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ArticleRequest<Article> asynData = ArticleRequest<Article>();
  List<Preferences> userPreference = StorageApi.getprefference();
  AsyncRequest<Article> request = AsyncRequest(interest: "");
  ScrollController scrollController = ScrollController();
  Connectivity connectivity = Connectivity();
  bool fetchedLocally = false;
  void getArticles() async {
    List<ConnectivityResult> allConnection =
        await connectivity.checkConnectivity();
    if (!fetchedLocally && allConnection.contains(ConnectivityResult.none)) {
      asynData.allData.addAll(StorageApi.getLocallArticle());
      fetchedLocally = true;
      request.fetchState = FetchState.hasdata;
      setState(() {});
      return;
    }
    String randomIntrest = userPreference.isNotEmpty
        ? userPreference[Random().nextInt(userPreference.length - 1)].interest
        : allPreferences[0].interest;
    try {
      request = getAsyncData(randomIntrest);
      request.fetchState = FetchState.fetching;
      setState(() {});
      ResponseModel response = await FetchApi.getRandomArticle(queries: {
        "q": randomIntrest,
        "page": request.pageNo,
        "language": "en"
      });
      Map newdata = response.body;
      List featchedArticles = (newdata["articles"] as List);
      featchedArticles.removeWhere((element) => element["content"] == null);
      List<Article> articles = featchedArticles = (newdata["articles"] as List)
          .map((e) => Article.fromJson(e))
          .toList();

      request.updatepageNo(newdata: newdata["articles"]);
      List<Article> filteredarticles = request.removeAllDublicate(
          articles, (otherItem) => (o) => otherItem.id == o.id);
      asynData.allData.addAll(filteredarticles);
      request.fetchState = FetchState.hasdata;
      if (mounted) {
        setState(() {});
      }
    } on ResponseModel {
      request.onError();
    }
  }

  AsyncRequest<Article> getAsyncData(String interest) {
    AsyncRequest<Article>? fetchedInterest = asynData.allAsyncRequest
        .firstWhereOrNull((element) => element.interest == interest);
    if (fetchedInterest != null) {
      return fetchedInterest;
    } else {
      AsyncRequest<Article> newRequest =
          AsyncRequest<Article>(interest: interest);
      asynData.allAsyncRequest.add(newRequest);
      return newRequest;
    }
  }

  @override
  void initState() {
    getArticles();
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
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "NewsFeed App",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: AsyncDataBuilder(
                    scrollController: scrollController,
                    snapshot: request,
                    data: asynData.allData,
                    size: size,
                    child: ListView.builder(
                      itemCount: asynData.allData.length,
                      itemBuilder: (context, index) {
                        return ArticleContainer(
                            article: asynData.allData[index]);
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
