class SilentOrderPostErrorResponse {
  SilentOrderPostErrorResponse({
    this.message,
    this.modelState,
  });

  String message;
  ModelState modelState;

  factory SilentOrderPostErrorResponse.fromJson(Map<String, dynamic> json) => SilentOrderPostErrorResponse(
    message: json["Message"],
    modelState: ModelState.fromJson(json["ModelState"]),
  );
}

class ModelState {
  ModelState({
    this.holderName,
    this.rawNumber,
    this.expiration,
    this.securityCode,
  });

  List<String> holderName;
  List<String> rawNumber;
  List<String> expiration;
  List<String> securityCode;

  factory ModelState.fromJson(Map<String, dynamic> json) => ModelState(
    holderName: List<String>.from(json["request.HolderName"].map((x) => x)),
    rawNumber: List<String>.from(json["request.RawNumber"].map((x) => x)),
    expiration: List<String>.from(json["request.Expiration"].map((x) => x)),
    securityCode: List<String>.from(json["request.SecurityCode"].map((x) => x)),
  );
}