import 'package:connect/features/auth/data/firebase_auth_repo.dart';
import 'package:connect/features/auth/domain/entities/app_user.dart';
import 'package:connect/features/auth/presentation/cubits/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CAuthCubit extends Cubit<CAuthState> {
  final CFirebaseAuthRepo authRepo;
  CAppUser? _currentUser;

  CAuthCubit({required this.authRepo}) : super(CAuthInitialState());

  // check if user is already authenticated
  void checkAuth() async {
    final CAppUser? user = await authRepo.getCurrentUser();
    if(user!=null){
      _currentUser = user;
      emit(CAuthAuthenticatedState(user));
    }
    else {
      emit(CAuthUnauthenticatedState());
    }
  }

  // get current user
  CAppUser? get currentUser => _currentUser;

  // login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(CAuthLoadingState());
      final user = await authRepo.loginWithEmailPassword(email, password);
      if(user != null) {
        _currentUser = user;
        emit(CAuthAuthenticatedState(user));
      } 
      else {
        emit(CAuthUnauthenticatedState());
      }
    }
    catch(e) {
      emit(CAuthErrorState(e.toString()));
      emit(CAuthUnauthenticatedState());
    }
  }

  // register with email and password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(CAuthLoadingState());
      final user = await authRepo.registerWithEmailPassword(name, email, password);
      if(user != null) {
        _currentUser = user;
        emit(CAuthAuthenticatedState(user));
      } 
      else {
        emit(CAuthUnauthenticatedState());
      }
    }
    catch(e) {
      emit(CAuthErrorState(e.toString()));
      emit(CAuthUnauthenticatedState());
    }
  }

  // logout
  Future<void> logout() async {
    _currentUser = null;
    await authRepo.logout();
    emit(CAuthUnauthenticatedState());
  }
}