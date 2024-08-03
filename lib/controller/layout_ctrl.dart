import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/screens/layout/chat/view.dart';
import 'package:social_3c/screens/layout/home/view.dart';
import 'package:social_3c/screens/layout/notifications/view.dart';
import 'package:social_3c/screens/layout/settings/view.dart';

import '../screens/layout/upload_post/view.dart';

class LayoutCtrl extends Cubit<LayoutStates> {
  LayoutCtrl() : super(LayoutInitState());

  final screens = const [
    HomeView(),
    ChatView(),
    UploadPostView(),
    NotificationView(),
    SettingsView(),
  ];
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }
}

abstract class LayoutStates {}

class LayoutInitState extends LayoutStates {}

class ChangeIndexState extends LayoutStates {}
