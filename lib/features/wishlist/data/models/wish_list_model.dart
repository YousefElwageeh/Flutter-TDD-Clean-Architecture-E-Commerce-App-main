import 'dart:convert';

import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:flutter_localization/flutter_localization.dart';

class WishListModel {
  String? status;
  List<Product>? wishlists;
  String? currencyEn;
  String? currencyAr;
  String? sort;

  WishListModel({
    this.status,
    this.wishlists,
    this.currencyEn,
    this.currencyAr,
    this.sort,
  }) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    if (localization.currentLocale.localeIdentifier == 'ar') {
      currencyEn = currencyAr;
    }
  }

  factory WishListModel.fromRawJson(String str) =>
      WishListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
        status: json["status"],
        wishlists: json["wishlists"] == null
            ? []
            : List<Product>.from(
                json["wishlists"]!.map((x) => Product.fromJson(x["product"]))),
        currencyEn: json["currency_en"],
        currencyAr: json["currency_ar"],
        sort: json["sort"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "wishlists": wishlists == null
            ? []
            : List<dynamic>.from(wishlists!.map((x) => x.toJson())),
        "currency_en": currencyEn,
        "currency_ar": currencyAr,
        "sort": sort,
      };
}
