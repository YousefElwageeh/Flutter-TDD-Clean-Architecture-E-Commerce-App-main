import 'dart:convert';
import 'dart:developer';

import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CartModel {
  bool? status;
  List<Cart>? cart;
  int? totalItems;
  int? totalPrice;
  Currency? currency;

  CartModel({
    this.status,
    this.cart,
    this.currency,
    this.totalItems,
    this.totalPrice,
  });

  factory CartModel.fromRawJson(String str) =>
      CartModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        status: json["status"],
        currency: Currency.fromJson(json["currency"]),
        cart: json["cart"] == null
            ? []
            : List<Cart>.from(json["cart"]!.map((x) => Cart.fromJson(x))),
        totalItems: json["total_items"],
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "currency": currency?.toJson(),
        "cart": cart == null
            ? []
            : List<dynamic>.from(cart!.map((x) => x.toJson())),
        "total_items": totalItems,
        "total_price": totalPrice,
      };
}

class Cart {
  int? qty;
  int? sizeKey;
  String? sizeQty;
  String? sizePrice;
  String? size;
  String? color;
  String? cartVar;
  int? stock;
  int? price;
  Product? item;
  String? license;
  String? dp;
  String? keys;
  String? values;
  dynamic image;

  Cart({
    this.qty,
    this.sizeKey,
    this.sizeQty,
    this.sizePrice,
    this.size,
    this.color,
    this.cartVar,
    this.stock,
    this.price,
    this.item,
    this.license,
    this.dp,
    this.keys,
    this.values,
    this.image,
  });

  factory Cart.fromRawJson(String str) => Cart.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cart.fromJson(Map<String, dynamic> json) {
    log(json["price"].toString());
    return Cart(
      qty: json["qty"],
      //  sizeKey: json["size_key"],
      sizeQty: json["size_qty"],
      sizePrice:
          json["size_price"] == null ? "" : json["size_price"].toString(),
      size: json["size"],
      //  color: json["color"],
      //  cartVar: json["var"],
      stock: json["stock"],
      price: json["price"],
      item: json["item"] == null ? null : Product.fromJson(json["item"]),
      // license: json["license"],
      // dp: json["dp"],
      // keys: json["keys"],
      // values: json["values"],
      // image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
        "qty": qty,
        "size_key": sizeKey,
        "size_qty": sizeQty,
        "size_price": sizePrice,
        "size": size,
        "color": color,
        "var": cartVar,
        "stock": stock,
        "price": price,
        "item": item?.toJson(),
        "license": license,
        "dp": dp,
        "keys": keys,
        "values": values,
        "image": image,
      };
}

class Currency {
  int? id;
  String? name;
  String? nameAr;
  String? sign;
  int? value;
  String? image;
  int? isDefault;

  Currency({
    this.id,
    this.name,
    this.nameAr,
    this.sign,
    this.value,
    this.image,
    this.isDefault,
  }) {
    final FlutterLocalization localization = FlutterLocalization.instance;

    if (localization.currentLocale.localeIdentifier == 'ar') {
      name = nameAr;
    }
  }

  factory Currency.fromRawJson(String str) =>
      Currency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        sign: json["sign"],
        value: json["value"],
        image: json["image"],
        isDefault: json["is_default"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "sign": sign,
        "value": value,
        "image": image,
        "is_default": isDefault,
      };
}
