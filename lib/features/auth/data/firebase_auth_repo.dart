import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/auth/domain/entities/app_user.dart';
import 'package:connect/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This class implements authentication methods using Firebase Authentication
class CFirebaseAuthRepo implements CAuthRepo {
  // Get an instance of Firebase Authentication to interact with Firebase Auth services
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<CAppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // Attempt to sign in with the provided email and password
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a CAppUser instance using the retrieved Firebase user details
      CAppUser user = CAppUser(
        uid: userCredential.user!.uid, // Unique user ID from Firebase
        email: email, // User's email
        name: '', // Name is left empty as Firebase does not provide it directly
      );
      return user;

    } catch (e) {
      // Catch any errors and throw a custom exception
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<CAppUser?> registerWithEmailPassword(String name, String email, String password) async {
    try {
      // Attempt to create a new user with email and password
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a CAppUser instance with user details
      CAppUser user = CAppUser(
        uid: userCredential.user!.uid, // Unique user ID from Firebase
        email: email, // User's email
        name: name, // Name provided by the user during registration
      );

      // save user's data in firebase database.
      await firebaseFirestore
      .collection('users')
      .doc(user.uid)
      .set(user.toJson());
      
      return user;
    } catch (e) {
      // Catch any errors and throw a custom exception
      throw Exception('Registration Failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    // Sign out the currently logged-in user
    await firebaseAuth.signOut();
  }

  @override
  Future<CAppUser?> getCurrentUser() async {
    // Get the currently authenticated user from Firebase
    final firebaseUser = firebaseAuth.currentUser;

    // If no user is logged in, return null
    if (firebaseUser == null) {
      return null;
    } else {
      // Return a CAppUser instance with user details
      return CAppUser(
        uid: firebaseUser.uid, // Unique user ID
        email: firebaseUser.email!, // User's email (non-nullable assumption)
        name: '', // Name is not stored in Firebase Auth, so it's left empty
      );
    }
  }
}
