import 'package:flutter/material.dart';

import 'package:news_app/api/async_data_fetch_api.dart';
import 'package:news_app/enum/data_fetch_enum.dart';
import 'package:news_app/style/text_style.dart';

class AsyncDataBuilder<T> extends StatelessWidget {
  const AsyncDataBuilder(
      {super.key,
      required this.child,
      required this.scrollController,
      required this.snapshot,
      required this.size,
      this.emptyData,
      this.errorWidget,
      this.loadingChild,
      required this.data});
  final Widget child;
  final ScrollController scrollController;
  final AsyncDataFetch<T> snapshot;
  final List<T> data;
  final Size size;
  final Widget? emptyData;
  final Widget? errorWidget;
  final Widget? loadingChild;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Builder(
        builder: (context) {
          switch (snapshot.fetchState) {
            case FetchState.fetching:
              return data.isNotEmpty
                  ? loadingChild ??
                      SizedBox.expand(
                        child: Column(
                          children: [
                            Expanded(child: child),
                            Container(
                              width: size.width,
                              height: 30,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            )
                          ],
                        ),
                      )
                  : loadingChild ??
                      const Center(child: CircularProgressIndicator());
            case FetchState.hasdata:
              return data.isEmpty
                  ? SizedBox.expand(
                      child: emptyData ??
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Items To Display",
                              style: sectionHeaderStyle,
                            ),
                          ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(child: child),
                          if (snapshot.haserror & data.isNotEmpty) ...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(9),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: const Icon(Icons.clear)),
                                const SizedBox(
                                  width: 9,
                                ),
                                const Text("Unknown Error Occur"),
                              ],
                            )
                          },
                          if (scrollController.hasClients &&
                              scrollController.position.maxScrollExtent >=
                                  size.height &&
                              !snapshot.hasMoreData &&
                              scrollController.offset ==
                                  scrollController.position.maxScrollExtent)
                            Container(
                              padding: const EdgeInsets.all(9),
                              child: const Text(
                                "No More Data",
                              ),
                            )
                        ],
                      ),
                    );
            case FetchState.haserror:
              return errorWidget ??
                  const Center(child: Text("Unknown Error Occur"));
          }
        },
      ),
    );
  }
}
