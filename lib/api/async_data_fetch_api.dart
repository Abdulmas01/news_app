import 'package:news_app/enum/data_fetch_enum.dart';

class AsyncDataFetch<T> {
  FetchState fetchState = FetchState.fetching;
  int pageNo = 1;
  String? nextpage;
  String? errorMessage;
  bool hasMoreData = true;
  bool firstFeach = true;
  bool haserror = false;
  int totalItem = 0;
  bool fullFeatch = true;
  List<T> data = [];

  void initFetch() {
    errorMessage = null;
    fetchState = FetchState.fetching;
    if (!firstFeach) {
      pageNo += 10;
    }
    if (haserror == true) {
      haserror = false;
    }
  }

  void updatepageNo({required List newdata}) {
    // when the fetch data is not up to ten which is the limit
    // the the pageNo it reduce so the next fetch
    // will statrt from their
    if (newdata.isEmpty) {
      pageNo -= 10;
      fullFeatch = true;
    } else if (newdata.length < 10 && firstFeach != true) {
      pageNo -= (10 - newdata.length);
      fullFeatch = false;
    } else if (newdata.length < 10 && firstFeach == true) {
      pageNo += newdata.length;
      fullFeatch = false;
    } else {
      fullFeatch = true;
    }
  }

  void onError() {
    if (firstFeach) {
      fetchState = FetchState.haserror;
    }
    if (data.isNotEmpty) {
      haserror = true;
      pageNo -= 10;
      fetchState = FetchState.hasdata;
    }
  }

  List<T> removeAllDublicate(
      List<T> newdata, bool Function(T testItem) Function(T otherItem) test) {
    if (data.isEmpty) {
      data.addAll(newdata);
      return newdata;
    } else {
      for (var element in data) {
        newdata.removeWhere(test(element));
      }
      data.addAll(newdata.toList());
      return newdata;
    }
  }
}

class AsyncWebsoket {
  int limit = 10;
  int pageNo = 0;
  int oldcount = 0;
  int newcount = 0;
  int countDifference = 0;
  bool firstFetch = true;
  bool useSocket = false;
}
