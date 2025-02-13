import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/profile/domain/entities/profile_user.dart';
import 'package:connect/features/profile/domain/repos/profile_repo.dart';

class CFirebaseProfileRepo implements CProfileRepo {
  // get firebase firestore instance
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<CProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .get();
      if(userDoc.exists) {
        final userData = userDoc.data();
        if(userData != null) {
          return CProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
          );
        }
      }
      return null;
    } catch(e) {
      return null;
    }
  }
  
  @override
  Future<void> updateProfile(CProfileUser updatedProfile) async {
    try {
      await firebaseFirestore
      .collection('users')
      .doc(updatedProfile.uid)
      .update({
        'bio':updatedProfile.bio,
        'profileImageUrl':updatedProfile.profileImageUrl,
      });
    }
    catch(e) {
      throw Exception(e);
    }
  }
}