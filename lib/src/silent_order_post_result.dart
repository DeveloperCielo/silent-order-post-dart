import 'package:cielo_silent_order_post/src/silent_order_post_error_response.dart';
import 'package:cielo_silent_order_post/src/silent_order_post_response.dart';

class SilentOrderPostResult {
  SilentOrderPostResponse response;
  SilentOrderPostErrorResponse error;
  int statusCode;

  SilentOrderPostResult({this.response, this.error, this.statusCode});
}