import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  String? token;
  String? name;
  int? id;
  String? phone;
  String? image;
  String? email;

  User({
    this.token,
    this.name,
    this.image,
    this.id,
    this.phone,
    this.email,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token"],
        name: json["name"],
        id: json["id"],
        phone: json["phone"],
        email: json["email"],
        image: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "name": name,
        "id": id,
        "email": email,
        "phone": phone,
        "photo": image,
      };

  @override
  List<Object> get props => [
        id ?? '',
        name ?? '',
        phone ?? '',
        token ?? '',
        email ?? '',
        image ?? '',
      ];
}
