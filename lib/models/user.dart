
// To parse this JSON data, do
//
//     final user = usuarioFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.online,
    required this.name,
    required this.email,
    required this.uid,
    required this.google,
    required this.img,
  });

  bool online;
  String name;
  String email;
  String uid;
  bool google;
  String? img ;

  factory User.fromJson(Map<String, dynamic> json) => User(
    online: json["online"],
    name: json["name"],
    email: json["email"],
    uid: json["uid"],
    google: json["google"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "online": online,
    "name": name,
    "email": email,
    "uid": uid,
    "google": google,
    "img": img,
  };
}