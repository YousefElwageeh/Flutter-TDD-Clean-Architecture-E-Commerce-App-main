import 'dart:convert';

import 'package:flutter_localization/flutter_localization.dart';

class CategoryModel {
  List<Category>? category;

  CategoryModel({
    this.category,
  });

  factory CategoryModel.fromRawJson(String str) =>
      CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        category: json["category"] == null
            ? []
            : List<Category>.from(
                json["category"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
      };
}

class Category {
  int? id;
  String? name;
  String? nameAr;
  String? slug;
  String? slugAr;
  int? status;
  dynamic photo;
  int? isFeatured;
  dynamic image;
  String? title;
  String? titleAr;
  dynamic metaTag;
  dynamic metaDescription;
  dynamic metaDescriptionAr;
  dynamic tags;
  dynamic tagsAr;
  dynamic details;
  dynamic detailsAr;
  dynamic deletedAt;
  dynamic erpId;

  Category({
    this.id,
    this.name,
    this.nameAr,
    this.slug,
    this.slugAr,
    this.status,
    this.photo,
    this.isFeatured,
    this.image,
    this.title,
    this.titleAr,
    this.metaTag,
    this.metaDescription,
    this.metaDescriptionAr,
    this.tags,
    this.tagsAr,
    this.details,
    this.detailsAr,
    this.deletedAt,
    this.erpId,
  }) {
    final FlutterLocalization localization = FlutterLocalization.instance;
    if (localization.currentLocale.localeIdentifier == 'ar') {
      details = detailsAr;
      name = nameAr;
    }
  }

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        slug: json["slug"],
        slugAr: json["slug_ar"],
        status: json["status"],
        photo: json["photo"],
        isFeatured: json["is_featured"],
        image: json["image"],
        title: json["title"],
        titleAr: json["title_ar"],
        metaTag: json["meta_tag"],
        metaDescription: json["meta_description"],
        metaDescriptionAr: json["meta_description_ar"],
        tags: json["tags"],
        tagsAr: json["tags_ar"],
        details: json["details"],
        detailsAr: json["details_ar"],
        deletedAt: json["deleted_at"],
        erpId: json["erp_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "slug": slug,
        "slug_ar": slugAr,
        "status": status,
        "photo": photo,
        "is_featured": isFeatured,
        "image": image,
        "title": title,
        "title_ar": titleAr,
        "meta_tag": metaTag,
        "meta_description": metaDescription,
        "meta_description_ar": metaDescriptionAr,
        "tags": tags,
        "tags_ar": tagsAr,
        "details": details,
        "details_ar": detailsAr,
        "deleted_at": deletedAt,
        "erp_id": erpId,
      }; // fromEntity method to map from another Category object
  Category.fromEntity(Category entity) {
    id = entity.id;
    name = entity.name;
    nameAr = entity.nameAr;
    slug = entity.slug;
    slugAr = entity.slugAr;
    photo = entity.photo;
    isFeatured = entity.isFeatured;
    image = entity.image;
    title = entity.title;
    titleAr = entity.titleAr;
    metaTag = entity.metaTag;
    metaDescription = entity.metaDescription;
    metaDescriptionAr = entity.metaDescriptionAr;
    tags = entity.tags;
    tagsAr = entity.tagsAr;
    details = entity.details;
    detailsAr = entity.detailsAr;
    deletedAt = entity.deletedAt;
    erpId = entity.erpId;
  }
}
