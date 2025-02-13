import 'package:connect/features/profile/domain/entities/profile_user.dart';

abstract class CProfileState {}

// initial
class CProfileInitialState extends CProfileState {}
// loading
class CProfileLoadingState extends CProfileState {}
// loaded
class CProfileLoadedState extends CProfileState {
  final CProfileUser profileUser;
  CProfileLoadedState(this.profileUser);
}
// error
class CProfileErrorState extends CProfileState {
  final String message;
  CProfileErrorState(this.message);
}