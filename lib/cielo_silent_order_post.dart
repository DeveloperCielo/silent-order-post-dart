library cielo_silent_order_post;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'src/access_token_response.dart';
import 'src/environment.dart';
import 'src/silent_order_post_request.dart';
import 'src/silent_order_post_response.dart';
import 'src/silent_order_post_error_response.dart';
import 'src/silent_order_post_result.dart';

export 'src/environment.dart';
export 'src/silent_order_post_request.dart';
export 'src/silent_order_post_response.dart';
export 'src/silent_order_post_error_response.dart';
export 'src/silent_order_post_result.dart';

class SilentOrderPost {
  final String merchantId;
  final Environment environment;
  bool binQuery = false;
  bool verifyCard = false;
  bool tokenize = false;
  String _baseUrl;

  SilentOrderPost({this.merchantId, this.environment}) {
    if (this.environment == Environment.PRODUCTION)
      this._baseUrl = "transaction.cieloecommerce.cielo.com.br";
    else
      this._baseUrl = "transactionsandbox.pagador.com.br";
  }

  Future<AccessTokenResult> _getAccessToken() async {
    AccessTokenResponse accessTokenResponse;

    final Uri uri = Uri.https(this._baseUrl, "/post/api/public/v1/accesstoken", {"merchantid" : this.merchantId});
    http.Response response = await http.post(uri);

    switch (response.statusCode) {
      case 201:
        accessTokenResponse = AccessTokenResponse.fromJson(jsonDecode(response.body));
        return AccessTokenResult(response: accessTokenResponse, statusCode: response.statusCode);
        break;
      case 401:
        return AccessTokenResult(error: "unauthorized", statusCode: response.statusCode);
      case 404:
        return AccessTokenResult(error: "not_found", statusCode: response.statusCode);
      default:
        return AccessTokenResult(error: "unknown_error", statusCode: response.statusCode);
    }
  }

  Future<SilentOrderPostResult> sendCardData(SilentOrderPostRequest request) async {
    AccessTokenResult resultFromAccessToken = await _getAccessToken();

    if (resultFromAccessToken.response?.accessToken != null) {
      request.accessToken = resultFromAccessToken.response.accessToken;
      final Uri uri = Uri.https(this._baseUrl, "/post/api/public/v1/card");
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          "Content-Type": "application/json"
        },
        body: jsonEncode(request.toJson()),
      );

      switch (response.statusCode) {
        case 201:
          return SilentOrderPostResult(response: SilentOrderPostResponse.fromJson(jsonDecode(response.body)), statusCode: response.statusCode);
        case 400:
          return SilentOrderPostResult(error: SilentOrderPostErrorResponse.fromJson(jsonDecode(response.body)), statusCode: response.statusCode);
        case 401:
          return SilentOrderPostResult(error: SilentOrderPostErrorResponse(message: "unauthorized"), statusCode: response.statusCode);
        case 404:
          return SilentOrderPostResult(error: SilentOrderPostErrorResponse(message: "not_found"), statusCode: response.statusCode);
        default:
          return SilentOrderPostResult(error: SilentOrderPostErrorResponse(message: "unknown_error"), statusCode: response.statusCode);
      }
    } else {
      return SilentOrderPostResult(error: SilentOrderPostErrorResponse(message: resultFromAccessToken.error), statusCode: resultFromAccessToken.statusCode);
    }
  }
}

class AccessTokenResult {
  AccessTokenResponse response;
  String error;
  int statusCode;

  AccessTokenResult({this.response, this.error, this.statusCode});
}