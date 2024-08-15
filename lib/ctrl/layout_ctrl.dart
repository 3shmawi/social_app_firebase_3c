import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/screens/layout/chat/chat_view.dart';
import 'package:social_3c/screens/layout/home/home_view.dart';
import 'package:social_3c/screens/layout/settings/settings_view.dart';
import 'package:social_3c/screens/layout/upload/upload_view.dart';

import '../screens/layout/notification/notification_view.dart';

class LayoutCtrl extends Cubit<LayoutStates> {
  LayoutCtrl() : super(LayoutInitialState());

  int currentIndex = 0;

  void changeIndex(int newIndex) {
    currentIndex = newIndex;
    emit(ChangeIndexState());
  }

  final _screens = const [
    HomeView(),
    ChatView(),
    UploadView(),
    NotificationView(),
    SettingsView(),
  ];

  Widget myScreen() => _screens[currentIndex];
}

abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class ChangeIndexState extends LayoutStates {}
