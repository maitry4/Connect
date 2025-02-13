import 'package:connect/features/profile/domain/entities/profile_user.dart';

abstract class CProfileRepo {
  Future<CProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(CProfileUser updatedProfile);
}