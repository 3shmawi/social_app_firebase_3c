import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/controller/comment_ctrl.dart';
import 'package:social_3c/controller/layout_ctrl.dart';
import 'package:social_3c/controller/post_ctrl.dart';
import 'package:social_3c/controller/settings_ctrl.dart';
import 'package:social_3c/screens/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCtrl()),
        BlocProvider(create: (context) => AuthCtrl()),
        BlocProvider(create: (context) => PostCtrl()..getPost()),
        BlocProvider(create: (context) => CommentCtrl()),
        BlocProvider(create: (context) => ChatCtrl()),
        BlocProvider(create: (context) => SettingsCtrl()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}
