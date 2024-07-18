import 'package:news_app/api/async_data_fetch_api.dart';

class ArticleRequest<T> {
  final List<AsyncRequest<T>> allAsyncRequest = [];
  List<T> allData = [];
}

class AsyncRequest<T> extends AsyncDataFetch<T> {
  final String interest;

  AsyncRequest({required this.interest});
}
