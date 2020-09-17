library cielo_silent_order_post;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'src/access_token_response.dart';
import 'src/environment.dart';
import 'src/silent_order_post_error_response.dart';
import 'src/silent_order_post_request.dart';
import 'src/silent_order_post_response.dart';
import 'src/silent_order_post_result.dart';

export 'src/environment.dart';
export 'src/silent_order_post_error_response.dart';
export 'src/silent_order_post_request.dart';
export 'src/silent_order_post_response.dart';
export 'src/silent_order_post_result.dart';

class SilentOrderPost {
  final String merchantId;
  final Environment environment;
  bool binQuery = false;
  bool verifyCard = false;
  bool tokenize = false;
  String _baseUrl;

  SilentOrderPost({this.merchantId, this.environment}) {
    this._baseUrl = getBaseUrl(environment);
  }

  Future<AccessTokenResult> _getAccessToken() async {
    AccessTokenResponse accessTokenResponse;

    final Uri uri = Uri.https(this._baseUrl, "/post/api/public/v1/accesstoken",
        {"merchantid": this.merchantId});
    http.Response response = await http.post(uri);

    return checkResponseAccessToken(response, accessTokenResponse);
  }

  Future<SilentOrderPostResult> sendCardData(
      SilentOrderPostRequest request) async {
    AccessTokenResult resultFromAccessToken = await _getAccessToken();

    if (resultFromAccessToken.response?.accessToken != null) {
      http.Response response =
          await sendRequest(request, resultFromAccessToken, this._baseUrl);

      return checkSendCardDataResponse(response);
    } else {
      return SilentOrderPostResult(
          error: SilentOrderPostErrorResponse(
              message: resultFromAccessToken.error),
          statusCode: resultFromAccessToken.statusCode);
    }
  }

  SilentOrderPostResult checkSendCardDataResponse(http.Response response) {
    switch (response.statusCode) {
      case 201:
        return SilentOrderPostResult(
            response:
                SilentOrderPostResponse.fromJson(jsonDecode(response.body)),
            statusCode: response.statusCode);
      case 400:
        return SilentOrderPostResult(
            error: SilentOrderPostErrorResponse.fromJson(
                jsonDecode(response.body)),
            statusCode: response.statusCode);
      case 401:
        return SilentOrderPostResult(
            error: SilentOrderPostErrorResponse(message: "unauthorized"),
            statusCode: response.statusCode);
      case 404:
        return SilentOrderPostResult(
            error: SilentOrderPostErrorResponse(message: "not_found"),
            statusCode: response.statusCode);
      default:
        return SilentOrderPostResult(
            error: SilentOrderPostErrorResponse(message: "unknown_error"),
            statusCode: response.statusCode);
    }
  }
}

String getBaseUrl(Environment environment) {
  return environment == Environment.PRODUCTION
      ? "transaction.cieloecommerce.cielo.com.br"
      : "transactionsandbox.pagador.com.br";
}

AccessTokenResult checkResponseAccessToken(
    http.Response response, AccessTokenResponse accessTokenResponse) {
  switch (response.statusCode) {
    case 201:
      accessTokenResponse =
          AccessTokenResponse.fromJson(jsonDecode(response.body));
      return AccessTokenResult(
          response: accessTokenResponse, statusCode: response.statusCode);
      break;
    case 401:
      return AccessTokenResult(
          error: "unauthorized", statusCode: response.statusCode);
    case 404:
      return AccessTokenResult(
          error: "not_found", statusCode: response.statusCode);
    default:
      return AccessTokenResult(
          error: "unknown_error", statusCode: response.statusCode);
  }
}

Future<http.Response> sendRequest(SilentOrderPostRequest request,
    AccessTokenResult resultFromAccessToken, String baseUrl) async {
  var sdkName = "CieloSilentOrderPost";
  var sdkVersion = "1.0.2";

  request.accessToken = resultFromAccessToken.response.accessToken;
  final Uri uri = Uri.https(baseUrl, "/post/api/public/v1/card");
  return await http.post(
    uri,
    headers: <String, String>{
      "Content-Type": "application/json",
      "x-sdk-version": "$sdkName-Dart@$sdkVersion"
    },
    body: jsonEncode(request.toJson()),
  );
}

class AccessTokenResult {
  AccessTokenResponse response;
  String error;
  int statusCode;

  AccessTokenResult({this.response, this.error, this.statusCode});
}
