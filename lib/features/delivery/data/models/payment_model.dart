import 'dart:convert';

import 'package:flutter_localization/flutter_localization.dart';

class PaymentMethodModel {
  String? status;
  List<Payment>? payments;

  PaymentMethodModel({
    this.status,
    this.payments,
  });

  factory PaymentMethodModel.fromRawJson(String str) =>
      PaymentMethodModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        status: json["status"],
        payments: json["payment"] == null
            ? []
            : List<Payment>.from(
                json["payment"]!.map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "payment": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
      };
}

class Payment {
  int? id;
  String? title;
  String? titleAr;
  String? subtitle;
  String? details;
  String? detailsAr;
  int? status;

  Payment({
    this.id,
    this.title,
    this.titleAr,
    this.subtitle,
    this.details,
    this.detailsAr,
    this.status,
  }) {
    FlutterLocalization localization = FlutterLocalization.instance;

    if (localization.currentLocale.localeIdentifier == 'ar') {
      title = titleAr;
      details = detailsAr;
    }
  }

  factory Payment.fromRawJson(String str) => Payment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        title: json["title"],
        titleAr: json["title_ar"],
        subtitle: json["subtitle"],
        details: json["details"],
        detailsAr: json["details_ar"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "title_ar": titleAr,
        "subtitle": subtitle,
        "details": details,
        "details_ar": detailsAr,
        "status": status,
      };
}
