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
        return CProfileUser.fromJson(userDoc.data()!);
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
    return null;
  }
  // Fetch multiple user profiles at once
  @override
  Future<List<CProfileUser>> fetchMultipleUserProfiles(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    try {
      final querySnapshot = await firebaseFirestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      return querySnapshot.docs.map((doc) => CProfileUser.fromJson(doc.data())).toList();
    } catch (e) {
      print("Error fetching multiple profiles: $e");
      return [];
    }
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
  
  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      // get both the users
      final currentUserDoc = await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDoc = await firebaseFirestore.collection('users').doc(targetUid).get();

      // see if they are present
      if (currentUserDoc.exists && targetUserDoc.exists) {
        // get data from both
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        // check if the data is correct
        if (currentUserData != null && targetUserData != null){
          // get current followings
          final List<String> currentFollowing = List<String>.from(currentUserData['following'] ?? []);

          // check if the user is already following the target user.
          if(currentFollowing.contains(targetUid)) {
            // unfollow
            // remove from current user
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following':FieldValue.arrayRemove([targetUid]),
            });
            // remove from target user
            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers':FieldValue.arrayRemove([currentUid]),
            });
          } else {
            // follow
            // add to current user
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following':FieldValue.arrayUnion([targetUid]),
            });
            // remove from target user
            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers':FieldValue.arrayUnion([currentUid]),
            });
          }
        }
      }
    } catch(e) {

    }
  }
  
}
