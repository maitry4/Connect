import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/profile/data/imagekit_repo.dart';
import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/domain/repos/profile_repo.dart';

class CFirebaseProfileRepo implements CProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final ImageKitRepo imageKitRepo = ImageKitRepo();

  @override
  Future<CProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return CProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            profileImageId: userData['profileImageId'],
          );
        }
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
    return null;
  }

  @override
  Future<void> updateProfile(CProfileUser updatedProfile) async {
    try {
      await firebaseFirestore.collection('users').doc(updatedProfile.uid).update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl,
        'profileImageId': updatedProfile.profileImageId,
      });
    } catch (e) {
      print("Error updating profile: $e");
      throw Exception("Profile update failed.");
    }
  }

  @override
  Future<String?> uploadProfileImage(String uid, dynamic file) async {
  if (file == null) return null; // Ensure there's an image to upload
  
  try {
    final imageUrl = await imageKitRepo.uploadImage(file, uid);
    if (imageUrl == null || imageUrl['url'] == null) {
      print("Failed to upload image.");
      return null;
    }

    final imageId = await imageKitRepo.getFileId(imageUrl['url']!);
    if (imageId != null) {
      await firebaseFirestore.collection('users').doc(uid).update({
        'profileImageUrl': imageUrl['url'],
        'profileImageId': imageId,
      });
    }
    
    return imageUrl['url'];
  } catch (e) {
    print("Profile Image Upload Error: $e");
    return null;
  }
}


  @override
  Future<void> deleteProfileImage(String imageUrl, String? imageId) async {
    try {
      if (imageId == null) {
        print("No Image ID found for deletion.");
        return;
      }
      await imageKitRepo.deleteImage(imageId);
      print("Profile image deleted successfully.");
    } catch (e) {
      print("Error deleting profile image: $e");
      throw Exception("Failed to delete profile image.");
    }
  }
}
