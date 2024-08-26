import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/controller/chat_ctrl.dart';
import 'package:social_3c/controller/comment_ctrl.dart';
import 'package:social_3c/controller/layout_ctrl.dart';
import 'package:social_3c/controller/posts_ctrl.dart';
import 'package:social_3c/screens/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCtrl()),
        BlocProvider(create: (context) => AuthCtrl()),
        BlocProvider(create: (context) => PostsCtrl()..fetchPosts()),
        BlocProvider(create: (context) => ChatCtrl()),
        BlocProvider(create: (context) => CommentsCtrl()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}
