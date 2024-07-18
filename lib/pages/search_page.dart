import 'package:flutter/material.dart';
import 'package:news_app/api/fetch_api.dart';
import 'package:news_app/api/snackbar_api.dart';
import 'package:news_app/enum/data_fetch_enum.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/article_request_model.dart';
import 'package:news_app/models/request_model.dart';
import 'package:news_app/style/box_shadow.dart';
import 'package:news_app/utils/apis.dart';
import 'package:news_app/widget/article_container.dart';
import 'package:news_app/widget/async_data_builder.dart';
import 'package:news_app/widget/button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool showFilter = false;
  bool showSearch = false;
  String? searchIN;
  List<String> possibleSearchIn = ['title', 'discription', 'content'];
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  AsyncRequest<Article> request = AsyncRequest(interest: "");

  final ScrollController controller = ScrollController();
  int page = 1;

  void search() async {
    if (searchController.text.isEmpty) {
      SnackbarApi()
          .snackbar(context: context, text: "Please Enter Any Key Pharase");
    }
    Map<String, dynamic> queries = {
      "q": searchController.text,
      "searchIn": searchIN ?? "title",
      "language": "en",
      "pageSize": 50,
      "page": page
    };
    showSearch = false;
    request.fetchState = FetchState.fetching;
    setState(() {});
    try {
      ResponseModel response =
          await FetchApi(api: newsApiEverything).getNoPath(queries: queries);
      Map newdata = response.body;
      List<Article> articles = (newdata["articles"] as List)
          .map((e) => Article.fromJson(e))
          .toList();

      request.updatepageNo(newdata: newdata["articles"]);
      List<Article> filteredarticles = request.removeAllDublicate(
          articles, (otherItem) => (o) => otherItem.id == o.id);
      request.data.addAll(filteredarticles);
      request.fetchState = FetchState.hasdata;
      setState(() {});
    } on ResponseModel catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        showSearch = false;
        showFilter = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Colors.white, boxShadow: containerShadows),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onTap: () {
                              if (showSearch == false) {
                                showSearch = true;
                                setState(() {});
                              }
                            },
                            decoration: const InputDecoration(
                                hintText: "Enters keywords ",
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              showFilter = !showFilter;
                              showSearch = false;
                              setState(() {});
                            },
                            icon: const Icon(Icons.filter_list_sharp))
                      ],
                    ),
                  ),
                  Expanded(
                      child: AsyncDataBuilder(
                          scrollController: scrollController,
                          snapshot: request,
                          data: request.data,
                          size: size,
                          child: ListView.builder(
                            itemCount: request.data.length,
                            itemBuilder: (context, index) {
                              return ArticleContainer(
                                  article: request.data[index]);
                            },
                          )))
                ],
              ),
              AnimatedPositioned(
                  left: showSearch ? (size.width / 2) - 60 : -size.width,
                  top: 60,
                  duration: const Duration(milliseconds: 750),
                  child: Button(
                    text: "Search",
                    width: 120,
                    callback: search,
                  )),
              AnimatedPositioned(
                  right: showFilter ? 0 : -size.width,
                  duration: const Duration(milliseconds: 750),
                  child: Container(
                    child: Column(
                      children: [
                        DropdownButton(
                          hint: const Text("Select SearchIn "),
                          items: possibleSearchIn
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            searchIN = value!;
                          },
                        ),
                        Button(
                            text: "Done",
                            callback: () {
                              showFilter = false;
                              showSearch = true;
                              setState(() {});
                            })
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
