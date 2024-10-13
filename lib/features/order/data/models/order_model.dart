import 'dart:convert';

import 'package:eshop/features/cart/data/models/cart_item_model.dart';

class OrdersModel {
  String? status;
  List<Order>? orders;

  OrdersModel({
    this.status,
    this.orders,
  });

  factory OrdersModel.fromRawJson(String str) =>
      OrdersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        status: json["status"],
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  int? id;
  int? userId;
  dynamic branchId;
  int? isPickup;
  List<Cart>? cart;
  String? method;
  String? shipping;
  dynamic pickupLocation;
  String? totalQty;
  int? payAmount;
  dynamic txnid;
  dynamic chargeId;
  int? orderNumber;
  String? paymentStatus;
  String? customerEmail;
  String? customerName;
  String? customerCountry;
  String? customerPhone;
  String? customerAddress;
  String? customerCity;
  dynamic customerZip;
  dynamic companyName;
  dynamic shippingName;
  dynamic shippingCountry;
  dynamic shippingEmail;
  dynamic shippingPhone;
  dynamic shippingAddress;
  dynamic shippingCity;
  dynamic shippingZip;
  dynamic orderNote;
  dynamic couponCode;
  String? couponDiscount;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic affilateUser;
  dynamic affilateCharge;
  String? currencySign;
  int? currencyValue;
  int? shippingCost;
  int? packingCost;
  int? tax;
  int? shipmentId;
  int? shippingPrice;
  int? shippingTax;
  String? taxValue;
  int? dp;
  dynamic payId;
  int? vendorShippingId;
  int? vendorPackingId;
  int? wallet;
  dynamic companyFastloApi;
  dynamic aramexApiNumbeer;
  dynamic idApiAramex;
  dynamic pickuptrackApi;
  int? orderCompleted;
  dynamic domainName;
  String? addDomain;
  dynamic serial;
  dynamic fedexPicApi;
  dynamic awb;
  dynamic pickupId;
  dynamic barcod;
  dynamic affilateUserId;
  dynamic invoiceUrl;
  dynamic tapOrderId;
  dynamic paymentResponse;
  String? vatPercentage;
  Shipmentmethod? shipmentmethod;
  dynamic paymentmethod;
  List<Orderstatus>? orderstatus;

  Order({
    this.id,
    this.userId,
    this.branchId,
    this.isPickup,
    this.cart,
    this.method,
    this.shipping,
    this.pickupLocation,
    this.totalQty,
    this.payAmount,
    this.txnid,
    this.chargeId,
    this.orderNumber,
    this.paymentStatus,
    this.customerEmail,
    this.customerName,
    this.customerCountry,
    this.customerPhone,
    this.customerAddress,
    this.customerCity,
    this.customerZip,
    this.companyName,
    this.shippingName,
    this.shippingCountry,
    this.shippingEmail,
    this.shippingPhone,
    this.shippingAddress,
    this.shippingCity,
    this.shippingZip,
    this.orderNote,
    this.couponCode,
    this.couponDiscount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.affilateUser,
    this.affilateCharge,
    this.currencySign,
    this.currencyValue,
    this.shippingCost,
    this.packingCost,
    this.tax,
    this.shipmentId,
    this.shippingPrice,
    this.shippingTax,
    this.taxValue,
    this.dp,
    this.payId,
    this.vendorShippingId,
    this.vendorPackingId,
    this.wallet,
    this.companyFastloApi,
    this.aramexApiNumbeer,
    this.idApiAramex,
    this.pickuptrackApi,
    this.orderCompleted,
    this.domainName,
    this.addDomain,
    this.serial,
    this.fedexPicApi,
    this.awb,
    this.pickupId,
    this.barcod,
    this.affilateUserId,
    this.invoiceUrl,
    this.tapOrderId,
    this.paymentResponse,
    this.vatPercentage,
    this.shipmentmethod,
    this.paymentmethod,
    this.orderstatus,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        userId: json["user_id"],
        branchId: json["branch_id"],
        isPickup: json["is_pickup"],
        cart: json["cart"] == null
            ? []
            : List<Cart>.from(json["cart"]!.map((x) => Cart.fromJson(x))),
        method: json["method"],
        shipping: json["shipping"],
        pickupLocation: json["pickup_location"],
        totalQty: json["totalQty"],
        //  payAmount: json["pay_amount"],
        txnid: json["txnid"],
        chargeId: json["charge_id"],
        orderNumber: json["order_number"],
        paymentStatus: json["payment_status"],
        customerEmail: json["customer_email"],
        customerName: json["customer_name"],
        customerCountry: json["customer_country"],
        customerPhone: json["customer_phone"],
        customerAddress: json["customer_address"],
        customerCity: json["customer_city"],
        customerZip: json["customer_zip"],
        companyName: json["company_name"],
        shippingName: json["shipping_name"],
        shippingCountry: json["shipping_country"],
        shippingEmail: json["shipping_email"],
        shippingPhone: json["shipping_phone"],
        shippingAddress: json["shipping_address"],
        shippingCity: json["shipping_city"],
        shippingZip: json["shipping_zip"],
        orderNote: json["order_note"],
        couponCode: json["coupon_code"],
        couponDiscount: json["coupon_discount"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        affilateUser: json["affilate_user"],
        affilateCharge: json["affilate_charge"],
        currencySign: json["currency_sign"],
        currencyValue: json["currency_value"],
        shippingCost: json["shipping_cost"],
        packingCost: json["packing_cost"],
        tax: json["tax"],
        shipmentId: json["shipment_id"],
        shippingPrice: json["shipping_price"],
        // shippingTax: json["shipping_tax"],
        // taxValue: json["tax_value"],
        // dp: json["dp"],
        // payId: json["pay_id"],
        // vendorShippingId: json["vendor_shipping_id"],
        // vendorPackingId: json["vendor_packing_id"],
        // wallet: json["wallet"],
        // companyFastloApi: json["company_fastlo_api"],
        // aramexApiNumbeer: json["aramex_api_numbeer"],
        // idApiAramex: json["id_api_aramex"],
        // pickuptrackApi: json["pickuptrack_api"],
        // orderCompleted: json["order_completed"],
        // domainName: json["domain_name"],
        // addDomain: json["add_domain"],
        // serial: json["serial"],
        // fedexPicApi: json["fedex_pic_api"],
        // awb: json["Awb"],
        // pickupId: json["pickup_id"],
        // barcod: json["barcod"],
        // affilateUserId: json["affilate_user_id"],
        // invoiceUrl: json["invoice_url"],
        // tapOrderId: json["tap_order_id"],
        // paymentResponse: json["payment_response"],
        // vatPercentage: json["vat_percentage"],
        // shipmentmethod: json["shipmentmethod"] == null
        //     ? null
        //     : Shipmentmethod.fromJson(json["shipmentmethod"]),
        // paymentmethod: json["paymentmethod"],
        // orderstatus: json["orderstatus"] == null
        //     ? []
        //     : List<Orderstatus>.from(
        //         json["orderstatus"]!.map((x) => Orderstatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "branch_id": branchId,
        "is_pickup": isPickup,
        "cart": cart == null
            ? []
            : List<dynamic>.from(cart!.map((x) => x.toJson())),
        "method": method,
        "shipping": shipping,
        "pickup_location": pickupLocation,
        "totalQty": totalQty,
        "pay_amount": payAmount,
        "txnid": txnid,
        "charge_id": chargeId,
        "order_number": orderNumber,
        "payment_status": paymentStatus,
        "customer_email": customerEmail,
        "customer_name": customerName,
        "customer_country": customerCountry,
        "customer_phone": customerPhone,
        "customer_address": customerAddress,
        "customer_city": customerCity,
        "customer_zip": customerZip,
        "company_name": companyName,
        "shipping_name": shippingName,
        "shipping_country": shippingCountry,
        "shipping_email": shippingEmail,
        "shipping_phone": shippingPhone,
        "shipping_address": shippingAddress,
        "shipping_city": shippingCity,
        "shipping_zip": shippingZip,
        "order_note": orderNote,
        "coupon_code": couponCode,
        "coupon_discount": couponDiscount,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "affilate_user": affilateUser,
        "affilate_charge": affilateCharge,
        "currency_sign": currencySign,
        "currency_value": currencyValue,
        "shipping_cost": shippingCost,
        "packing_cost": packingCost,
        "tax": tax,
        "shipment_id": shipmentId,
        "shipping_price": shippingPrice,
        "shipping_tax": shippingTax,
        "tax_value": taxValue,
        "dp": dp,
        "pay_id": payId,
        "vendor_shipping_id": vendorShippingId,
        "vendor_packing_id": vendorPackingId,
        "wallet": wallet,
        "company_fastlo_api": companyFastloApi,
        "aramex_api_numbeer": aramexApiNumbeer,
        "id_api_aramex": idApiAramex,
        "pickuptrack_api": pickuptrackApi,
        "order_completed": orderCompleted,
        "domain_name": domainName,
        "add_domain": addDomain,
        "serial": serial,
        "fedex_pic_api": fedexPicApi,
        "Awb": awb,
        "pickup_id": pickupId,
        "barcod": barcod,
        "affilate_user_id": affilateUserId,
        "invoice_url": invoiceUrl,
        "tap_order_id": tapOrderId,
        "payment_response": paymentResponse,
        "vat_percentage": vatPercentage,
        "shipmentmethod": shipmentmethod?.toJson(),
        "paymentmethod": paymentmethod,
        "orderstatus": orderstatus == null
            ? []
            : List<dynamic>.from(orderstatus!.map((x) => x.toJson())),
      };
}

class Orderstatus {
  int? id;
  int? orderId;
  String? title;
  String? text;
  DateTime? createdAt;
  DateTime? updatedAt;

  Orderstatus({
    this.id,
    this.orderId,
    this.title,
    this.text,
    this.createdAt,
    this.updatedAt,
  });

  factory Orderstatus.fromRawJson(String str) =>
      Orderstatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Orderstatus.fromJson(Map<String, dynamic> json) => Orderstatus(
        id: json["id"],
        orderId: json["order_id"],
        title: json["title"],
        text: json["text"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "title": title,
        "text": text,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Shipmentmethod {
  int? id;
  String? name;
  String? nameAr;
  String? desc;
  String? descAr;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? phone;
  int? shippingTax;
  String? photo;

  Shipmentmethod({
    this.id,
    this.name,
    this.nameAr,
    this.desc,
    this.descAr,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.shippingTax,
    this.photo,
  });

  factory Shipmentmethod.fromRawJson(String str) =>
      Shipmentmethod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shipmentmethod.fromJson(Map<String, dynamic> json) => Shipmentmethod(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        desc: json["desc"],
        descAr: json["desc_ar"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        phone: json["phone"],
        shippingTax: json["shipping_tax"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "desc": desc,
        "desc_ar": descAr,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "phone": phone,
        "shipping_tax": shippingTax,
        "photo": photo,
      };
}
