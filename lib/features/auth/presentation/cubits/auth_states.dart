import 'package:connect/features/auth/domain/entities/app_user.dart';

abstract class CAuthState {}

// initial 
class CAuthInitialState extends CAuthState {}

// loading
class CAuthLoadingState extends CAuthState {}

// Authenticated
class CAuthAuthenticatedState extends CAuthState {
    final CAppUser user;
    CAuthAuthenticatedState(this.user);
}

// unauthenticated
class CAuthUnauthenticatedState extends CAuthState {}

// errors...
class CAuthErrorState extends CAuthState {
    final String message;
    CAuthErrorState(this.message);
}
