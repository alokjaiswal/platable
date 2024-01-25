import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class PlatableUser {
  final String userId;
  final String? phoneNumber;
  final String? userName;
  final String? email;
  final String? profileUrl;


  PlatableUser({
    required this.userId,
    this.phoneNumber,
    this.userName,
    this.email,
    this.profileUrl
  });

  PlatableUser.fromJson(Map<String, Object?>? json)
    :this(
        userId: (json?['userId'] as String),
        phoneNumber: (json?['phoneNumber'] ?? "") as String,
        userName: (json?['userName'] ?? "") as String,
        email: (json?['email'] ?? "") as String,
        profileUrl: (json?['profileUrl'] ?? "") as String,
    );

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'email': email,
      'profileUrl': profileUrl,
    };
  }
}