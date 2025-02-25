import 'package:connect/features/profile/domain/entities/profile_user.dart';

abstract class CProfileRepo {
  Future<CProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(CProfileUser updatedProfile);
  Future<String?> uploadProfileImage(String uid, dynamic file);
  Future<void> deleteProfileImage(String imageUrl, String? imageId);
}