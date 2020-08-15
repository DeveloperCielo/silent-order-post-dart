class SilentOrderPostResponse {
  SilentOrderPostResponse({
    this.paymentToken,
    this.foreignCard,
    this.binQueryReturnCode,
    this.binQueryReturnMessage,
    this.cardBin,
    this.cardLast4Digits,
  });

  String paymentToken;
  bool foreignCard;
  String binQueryReturnCode;
  String binQueryReturnMessage;
  String cardBin;
  String cardLast4Digits;

  factory SilentOrderPostResponse.fromJson(Map<String, dynamic> json) => SilentOrderPostResponse(
    paymentToken: json["PaymentToken"],
    foreignCard: json["ForeignCard"],
    binQueryReturnCode: json["BinQueryReturnCode"],
    binQueryReturnMessage: json["BinQueryReturnMessage"],
    cardBin: json["CardBin"],
    cardLast4Digits: json["CardLast4Digits"],
  );
}