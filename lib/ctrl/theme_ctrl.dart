import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCtrl extends Cubit<bool> {
  ThemeCtrl() : super(false);

  void toggleTheme() {
    emit(!state);
  }
}
