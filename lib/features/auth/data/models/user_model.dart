import 'dart:convert';

import '../../domain/entities/user.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends User {
  UserModel({
    super.id,
    super.name,
    super.token,
    super.phone,
    super.email,
    super.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        token: json["token"],
        phone: json["phone"],
        email: json["email"],
        image: json["photo"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "token": token,
        "email": email,
        "photo": image,
      };
}
