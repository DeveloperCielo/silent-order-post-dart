class SilentOrderPostRequest {
  String accessToken;
  String holderName;
  String rawNumber;
  String expirationDate;
  String securityCode;
  bool enableBinQuery;

  SilentOrderPostRequest({this.holderName, this.rawNumber, this.expirationDate, this.securityCode, this.enableBinQuery = false});

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "holderName": holderName,
    "rawNumber": rawNumber,
    "expiration": expirationDate,
    "securityCode": securityCode,
    "enableBinQuery": enableBinQuery,
  };
}