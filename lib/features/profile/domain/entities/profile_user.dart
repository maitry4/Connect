import 'package:connect/features/auth/domain/entities/app_user.dart';

class CProfileUser extends CAppUser {
  final String bio;
  final String profileImageUrl;
  final String? profileImageId; // Added fileId
  final List<String> followers;
  final List<String> following;

  CProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
    this.profileImageId,
    required this.followers,
    required this.following,
  });

  // Method to update profile user
  CProfileUser copyWith({
    String? newBio, 
    String? newProfileImageUrl, 
    String? newProfileImageId,
    List<String>? newFollowers,
    List<String>? newFollowing,
    }) {
    return CProfileUser(
      uid: uid, 
      email: email, 
      name: name, 
      bio: newBio ?? bio, 
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      profileImageId: newProfileImageId ?? profileImageId,
      followers: newFollowers??followers,
      following: newFollowing??following,
    );
  }

  // Convert profile user -> json
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name, 
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'profileImageId': profileImageId,
      'followers':followers,
      'following':following,
    };
  }

  factory CProfileUser.fromJson(Map<String, dynamic> jsonUser) {
    return CProfileUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      bio: jsonUser['bio'],
      profileImageUrl: jsonUser['profileImageUrl'],
      profileImageId: jsonUser['profileImageId'],
      followers: List<String>.from(jsonUser['followers'] ?? []),
      following: List<String>.from(jsonUser['following'] ?? []),
    );
  }
}