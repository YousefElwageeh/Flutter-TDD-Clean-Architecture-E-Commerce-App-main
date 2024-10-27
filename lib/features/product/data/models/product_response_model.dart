import 'dart:convert';
import 'dart:developer';

import 'package:flutter_localization/flutter_localization.dart';

class ProductResponseModel {
  String? status;
  List<Product>? products;

  ProductResponseModel({
    this.status,
    this.products,
  });

  factory ProductResponseModel.fromRawJson(String str) =>
      ProductResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductResponseModel(
        status: json["status"],
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  int? id;
  String? sku;
  String? productType;
  int? userId;
  int? categoryId;
  int? brandId;
  String? name;
  String? nameAr;
  String? slug;
  String? slugAr;
  String? photo;
  String? thumbnail;
  List<String>? size;
  List<String>? sizeQty;
  List<String>? sizePrice;
  String? color;
  double? price;
  String? mobilePrice;
  String? previousPrice;
  String? details;
  String? detailsAr;
  int? stock;
  String? policy;
  String? policyAr;
  int? status;
  int? views;
  String? features;
  String? colors;
  int? productCondition;
  int? isMeta;
  String? metaTag;
  String? type;
  int? scale;
  int? big;
  int? trending;
  int? sale;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isDiscount;
  int? likes;
  String? offer;
  String? currencyAr;
  String? currencyEn;
  int? discount;

  Product({
    this.id,
    this.sku,
    this.productType,
    this.userId,
    this.categoryId,
    this.brandId,
    this.name,
    this.nameAr,
    this.slug,
    this.slugAr,
    this.photo,
    this.thumbnail,
    this.size,
    this.sizeQty,
    this.sizePrice,
    this.color,
    this.price,
    this.mobilePrice,
    this.previousPrice,
    this.details,
    this.detailsAr,
    this.stock,
    this.policy,
    this.policyAr,
    this.status,
    this.views,
    this.features,
    this.colors,
    this.productCondition,
    this.isMeta,
    this.metaTag,
    this.type,
    this.scale,
    this.big,
    this.trending,
    this.sale,
    this.createdAt,
    this.updatedAt,
    this.isDiscount,
    this.likes,
    this.offer,
    this.currencyAr,
    this.currencyEn,
    this.discount,
  }) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    if (localization.currentLocale.localeIdentifier == 'ar') {
      details = detailsAr;
      name = nameAr;
    }
  }

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        sku: json["sku"],
        productType: json["product_type"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        brandId: json["brand_id"],
        name: json["name"],
        nameAr: json["name_ar"],
        slug: json["slug"],
        slugAr: json["slug_ar"],
        photo: json["photo"],
        thumbnail: json["thumbnail"],
        size: json["size"] == null || json["size"] == ""
            ? []
            : List<String>.from(json["size"]!.map((x) => x)),
        sizeQty: json["size_qty"] == null || json["size_qty"] == ""
            ? []
            : List<String>.from(json["size_qty"]!.map((x) => x)),
        sizePrice: json["size_price"] == null || json["size_price"] == ""
            ? []
            : List<String>.from(json["size_price"]!.map((x) => x)),
        // color: json["color"],
        price: json["price"] + 0.0,
        mobilePrice: json["mobile_price"].toString(),
        // previousPrice: json["previous_price"],
        details: json["details"],
        detailsAr: json["details_ar"],
        stock: json["stock"],
        policy: json["policy"],
        policyAr: json["policy_ar"],
        status: json["status"],
        views: json["views"],
        features: json["features"],
        colors: json["colors"],
        productCondition: json["product_condition"],
        isMeta: json["is_meta"],
        metaTag: json["meta_tag"],
        type: json["type"],
        scale: json["scale"],
        big: json["big"],
        trending: json["trending"],
        sale: json["sale"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isDiscount: json["is_discount"],
        likes: json["likes"],
        offer: json["Offer"],
        currencyAr: json["currency_ar"],
        currencyEn: json["currency_en"],
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sku": sku,
        "product_type": productType,
        "user_id": userId,
        "category_id": categoryId,
        "brand_id": brandId,
        "name": name,
        "name_ar": nameAr,
        "slug": slug,
        "slug_ar": slugAr,
        "photo": photo,
        "thumbnail": thumbnail,
        "size": size,
        "size_qty": sizeQty,
        "size_price": sizePrice,
        "color": color,
        "price": price,
        "mobile_price": mobilePrice,
        "previous_price": previousPrice,
        "details": details,
        "details_ar": detailsAr,
        "stock": stock,
        "policy": policy,
        "policy_ar": policyAr,
        "status": status,
        "views": views,
        "features": features,
        "colors": colors,
        "product_condition": productCondition,
        "is_meta": isMeta,
        "meta_tag": metaTag,
        "type": type,
        "scale": scale,
        "big": big,
        "trending": trending,
        "sale": sale,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_discount": isDiscount,
        "likes": likes,
        "Offer": offer,
        "currency_ar": currencyAr,
        "currency_en": currencyEn,
        "discount": discount,
      };
}
