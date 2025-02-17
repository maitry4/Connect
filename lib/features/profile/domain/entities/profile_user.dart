import 'package:connect/features/auth/domain/entities/app_user.dart';

class CProfileUser extends CAppUser {
  final String bio;
  final String profileImageUrl;

  CProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
  });

  // Method to update profile user
  CProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return CProfileUser(
      uid: uid, 
      email: email, 
      name: name, 
      bio: newBio?? bio, 
      profileImageUrl: newProfileImageUrl?? profileImageUrl
    );
  }
  // convert profile user -> json
  @override
  Map<String, dynamic> toJson() {
    return {
      'uid':uid,
      'email':email,
      'name':name, 
      'bio':bio,
      'profileImageUrl':profileImageUrl,
    };
  }

  factory CProfileUser.fromJson(Map<String, dynamic> jsonUser) {
    return CProfileUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      bio: jsonUser['bio'],
      profileImageUrl:jsonUser['profileImageUrl'],
    );
  }
}