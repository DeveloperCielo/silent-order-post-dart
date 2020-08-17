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
    holderName: (json["request.HolderName"] != null) ? List<String>.from(json["request.HolderName"]?.map((x) => x)) : List<String>(),
    rawNumber: (json["request.RawNumber"] != null) ? List<String>.from(json["request.RawNumber"]?.map((x) => x)) : List<String>(),
    expiration: (json["request.Expiration"] != null) ? List<String>.from(json["request.Expiration"]?.map((x) => x)) : List<String>(),
    securityCode: (json["request.SecurityCode"] != null) ? List<String>.from(json["request.SecurityCode"]?.map((x) => x)) : List<String>(),
  );
}