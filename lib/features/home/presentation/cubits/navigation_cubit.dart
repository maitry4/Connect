import 'package:flutter_bloc/flutter_bloc.dart';

class CNavigationCubit extends Cubit<int> {
  CNavigationCubit() : super(0);

  void selectPage(int index) => emit(index);
}