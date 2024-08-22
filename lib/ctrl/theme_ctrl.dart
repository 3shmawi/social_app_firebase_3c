import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/services/local_database.dart';

class ThemeCtrl extends Cubit<bool> {
  ThemeCtrl() : super(false);

  void toggleTheme() {
    CacheHelper.saveData(key: "isDark", value: !state);
    emit(!state);
  }
}
