import "package:flutter/material.dart";

/// A model class that represents a user in the application.
///
/// The [UserModel] class is immutable and contains all the properties that define a user
/// in the application. It has properties such as email, name, followers, following, profilePic,
/// bannerPic, uid, bio and isTwitterBlue.
///
/// The [UserModel] class also contains methods for comparison, copying and conversion to and from
/// a map. It overrides the == operator to compare two [UserModel] objects based on their
/// properties. It also provides a copyWith method to create a new [UserModel] object with
/// updated properties. The toMap method is used to convert a [UserModel] object to a map
/// that can be stored in a database, and the fromMap method is used to create a [UserModel]
/// object from a map retrieved from a database.
@immutable
class UserModel {
  final String email;
  final String name;
  final List<String> followers;
  final List<String> following;
  final String profilePic;
  final String bannerPic;
  final String uid;
  final String bio;
  final bool isTwitterBlue;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,
    required this.isTwitterBlue,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          name == other.name &&
          followers == other.followers &&
          following == other.following &&
          profilePic == other.profilePic &&
          bannerPic == other.bannerPic &&
          uid == other.uid &&
          bio == other.bio &&
          isTwitterBlue == other.isTwitterBlue);

  @override
  int get hashCode =>
      email.hashCode ^
      name.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      profilePic.hashCode ^
      bannerPic.hashCode ^
      uid.hashCode ^
      bio.hashCode ^
      isTwitterBlue.hashCode;

  @override
  String toString() {
    return "UserModel{ email: $email, name: $name, followers: $followers, following: $following, profilePic: $profilePic, bannerPic: $bannerPic, uid: $uid, bio: $bio, isTwitterBlue: $isTwitterBlue,}";
  }

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? uid,
    String? bio,
    bool? isTwitterBlue,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  // we don't need to store id because appwrite will create it automatically
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "followers": followers,
      "following": following,
      "profilePic": profilePic,
      "bannerPic": bannerPic,
      "bio": bio,
      "isTwitterBlue": isTwitterBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map["email"] ?? "",
      name: map["name"] ?? "",
      followers: List<String>.from(map["followers"]),
      following: List<String>.from(map["following"]),
      profilePic: map["profilePic"] ?? "",
      bannerPic: map["bannerPic"] ?? "",
      // appwrite stores the id as $id
      uid: map["\$id"] ?? "",
      bio: map["bio"] ?? "",
      isTwitterBlue: map["isTwitterBlue"] ?? false,
    );
  }

//</editor-fold>
}
