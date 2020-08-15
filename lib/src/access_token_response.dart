class AccessTokenResponse {
  AccessTokenResponse({
    this.merchantId,
    this.accessToken,
    this.issued,
    this.expiresIn,
  });

  String merchantId;
  String accessToken;
  DateTime issued;
  DateTime expiresIn;

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) => AccessTokenResponse(
    merchantId: json["MerchantId"],
    accessToken: json["AccessToken"],
    issued: DateTime.parse(json["Issued"]),
    expiresIn: DateTime.parse(json["ExpiresIn"]),
  );
}
