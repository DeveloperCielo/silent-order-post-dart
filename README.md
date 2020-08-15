# cielo_silent_order_post

A Flutter package that helps to use Cielo's Silent Order Post.

## Usage

These operations must be performed using its specific key (Client Id, Client Secret and Merchand Id) in the respective environment endpoints.

```dart
var sop = SilentOrderPost(merchantId: "YOUR-MERCHANT-ID", environment: Environment.SANDBOX);
var result = await sop.sendCardData(
  SilentOrderPostRequest(
    holderName: "Maurici Ferreira Junior",
    rawNumber: "4111111111111111",
    expirationDate: "01/2030",
    securityCode: "123",
    enableBinQuery: false,
  )
);

print("STATUS-CODE: ${result?.statusCode}");

if (result?.response != null) {
  print("PAYMENT-TOKEN: ${result.response.paymentToken}");
}

if (result?.error != null) {
  if (result.error.message != null) {
    print("ERROR-MESSAGE: ${result.error.message}");
  }
  
  if (result.error.modelState != null) {
    print("VALIDATIONS:");
    if (result.error.modelState.holderName.isNotEmpty) {
      print("  - HOLDER-NAME:");
      result.error.modelState.holderName.forEach((message) {
        print("    - $message");
      });
    }
    if (result.error.modelState.rawNumber.isNotEmpty) {
      print("  - RAW-NUMBER:");
      result.error.modelState.rawNumber.forEach((message) {
        print("    - $message");
      });
    }
    if (result.error.modelState.expiration.isNotEmpty) {
      print("  - EXPIRATION-DATE:");
      result.error.modelState.expiration.forEach((message) {
        print("    - $message");
      });
    }
    if (result.error.modelState.securityCode.isNotEmpty) {
      print("  - SECURITY-CODE:");
      result.error.modelState.securityCode.forEach((message) {
        print("    - $message");
      });
    }
  }
}
```