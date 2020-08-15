import 'package:cielo_silent_order_post/src/silent_order_post_request.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cielo_silent_order_post/cielo_silent_order_post.dart';

void main() {
  String correctMerchantId = "YOUR-MERCHANT-ID";
  String incorrectMerchantId = "ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ";
  SilentOrderPostRequest correctRequest = SilentOrderPostRequest(
    holderName: "Maurici Ferreira Junior",
    rawNumber: "41111111111111111",
    expirationDate: "01/2030",
    securityCode: "123",
    enableBinQuery: false,
  );
  SilentOrderPostRequest incorrectRequest = SilentOrderPostRequest(
    holderName: "Maurici F Junior 1234567890",
    rawNumber: "AAAAAAAAAAAAAAAAA",
    expirationDate: "BB/CCCC",
    securityCode: "DDD",
    enableBinQuery: false,
  );

  group("Correct merchant id and correct request", () {
    SilentOrderPost sop;
    SilentOrderPostResult result;

    setUp(() async {
      sop = SilentOrderPost(merchantId: correctMerchantId, environment: Environment.SANDBOX);
      result = await sop.sendCardData(correctRequest);
    });

    test("should return status code 201 created", () {
      expect(result?.statusCode, 201);
    });

    test("should return success response", () {
      expect(result, isNotNull);
      expect(result?.response, isNotNull);
      expect(result?.response?.paymentToken, isNotNull);
    });

    test("should return null error response", () {
      expect(result?.error, isNull);
    });
  });

  group("Incorrect merchant id", () {
    SilentOrderPost sop;
    SilentOrderPostResult result;

    setUp(() async {
      sop = SilentOrderPost(merchantId: incorrectMerchantId, environment: Environment.SANDBOX);
      result = await sop.sendCardData(correctRequest);
    });

    test("should return status code 401 unauthorized", () {
      expect(result?.statusCode, 401);
    });

    test("should return error response", () {
      expect(result, isNotNull);
      expect(result?.error, isNotNull);
      expect(result?.error?.message, "unauthorized");
    });
  });

  group("Correct merchant id and incorrect card data", () {
    SilentOrderPost sop;
    SilentOrderPostResult result;

    setUp(() async {
      sop = SilentOrderPost(merchantId: correctMerchantId, environment: Environment.SANDBOX);
      result = await sop.sendCardData(incorrectRequest);
    });

    test("should return error response", () {
      expect(result, isNotNull);
      expect(result?.error, isNotNull);
      expect(result?.error?.modelState, isNotNull);
    });

    test("should return model state with validations", () {
      expect(result?.error?.modelState?.holderName, isNotEmpty);
      expect(result?.error?.modelState?.rawNumber, isNotEmpty);
      expect(result?.error?.modelState?.expiration, isNotEmpty);
      expect(result?.error?.modelState?.securityCode, isNotEmpty);
    });
  });

  group("Bin Query flag set as true", () {
    SilentOrderPost sop;
    SilentOrderPostResult result;
    correctRequest.enableBinQuery = true;

    setUp(() async {
      sop = SilentOrderPost(merchantId: correctMerchantId, environment: Environment.SANDBOX);
      result = await sop.sendCardData(correctRequest);
    });

    test("should return bin query result", () {
      expect(result, isNotNull);
      expect(result?.response, isNotNull);
      expect(result?.response?.binQueryReturnMessage, isNotNull);
      expect(result?.response?.binQueryReturnCode, isNotNull);
      expect(result?.response?.cardBin, isNotNull);
      expect(result?.response?.cardLast4Digits, isNotNull);
      expect(result?.response?.foreignCard, isNotNull);
    });
  });
}
