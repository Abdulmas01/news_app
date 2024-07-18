import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:news_app/models/request_model.dart';
import 'package:news_app/utils/apis.dart';
import 'package:news_app/utils/keys.dart';

class FetchApi {
  final String api;

  FetchApi({required this.api});
  Future<ResponseModel> get(
      {required String path, required Map<String, dynamic> queries}) async {
    http.Response response = await http.get(Uri.parse(api), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: apikey
    });
    return ResponseModel(statusCode: response.statusCode, sucessfull: true);
  }

  Future<ResponseModel> getNoPath(
      {required Map<String, dynamic> queries}) async {
    http.Response response =
        await http.get(Uri.parse(api + addQuery(queries)), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: apikey
    });
    return sendResponse(response);
  }

  static Future<ResponseModel> getRandomArticle(
      {required Map<String, dynamic> queries}) async {
    if (queries.isNotEmpty) {
      try {
        http.Response response = await http
            .get(Uri.parse(newsApiEverything + addQuery(queries)), headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: apikey
        });
        return sendResponse(response);
      } on http.ClientException {
        return Future.error(ResponseModel(statusCode: 1, sucessfull: false));
      }
    } else {
      http.Response response = await http.get(Uri.parse(newsApi), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      });
      return sendResponse(response);
    }
  }
}

Future<ResponseModel> sendResponse(http.Response response) async {
  switch (response.statusCode) {
    case 200:
      return ResponseModel(
          statusCode: 200,
          sucessfull: true,
          body: await jsonDecode(response.body));

    default:
      return Future.error(ResponseModel(
          statusCode: -2,
          sucessfull: false,
          errorType: "decode error",
          message: "fail to decode response"));
  }
}

String addQuery(Map<String, dynamic> query) {
  String formatedQuery = "?";
  for (var key in query.entries) {
    formatedQuery += "${key.key}=${key.value}&";
  }
  return formatedQuery.substring(0, formatedQuery.length - 1);
}

String failedValidationMessage(dynamic result) {
  String message = "";
  if (result is Map) {
    for (String element in (result).keys) {
      if (result[element] is List) {
        if (result[element].isNotEmpty) {
          message += ("$element ${result[element]} ,");
        }
      } else {
        message += (result[element] + ",");
      }
    }
    return message;
  }
  if (result is List) {
    for (var element in result) {
      message += (element + ",");
    }
  }

  return message;
}
