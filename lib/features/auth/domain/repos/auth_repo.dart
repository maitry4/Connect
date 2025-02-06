// Outlines the possible authentication related operations of this Connect.
import 'package:connect/features/auth/domain/entities/app_user.dart';

abstract class CAuthRepo {
  Future<CAppUser?> loginWithEmailPassword(String email, String password);
  Future<CAppUser?> registerWithEmailPassword(String name, String email, String password);
  Future<void> logout();
  Future<CAppUser?> getCurrentUser();
}