import 'package:connect/features/profile/domain/entities/profile_user.dart';

abstract class CProfileState {}

// initial
class CProfileInitialState extends CProfileState {}
// loading
class CProfileLoadingState extends CProfileState {}
// Loaded (Single User)
class CProfileLoadedState extends CProfileState {
  final CProfileUser profileUser;
  CProfileLoadedState(this.profileUser);
}

// Loaded (Multiple Users)
class CProfilesLoadedState extends CProfileState {
  final List<CProfileUser> profiles;
  CProfilesLoadedState(this.profiles);
}
// error
class CProfileErrorState extends CProfileState {
  final String message;
  CProfileErrorState(this.message);
}