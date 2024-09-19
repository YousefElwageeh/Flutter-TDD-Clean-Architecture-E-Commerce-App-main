import 'dart:convert';

class AddToCardRequest {
  int? id;
  String? qty;
  String? size;
  int? sizePrice;

  AddToCardRequest({
    this.id,
    this.qty,
    this.size,
    this.sizePrice,
  });

  factory AddToCardRequest.fromRawJson(String str) =>
      AddToCardRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddToCardRequest.fromJson(Map<String, dynamic> json) =>
      AddToCardRequest(
        id: json["id"],
        qty: json["qty"],
        size: json["size"],
        sizePrice: json["size_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qty": qty,
        "size": size,
        "size_price": sizePrice,
      };
}
