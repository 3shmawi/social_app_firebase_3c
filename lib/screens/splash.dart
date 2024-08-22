import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/auth_ctrl.dart';
import 'package:social_3c/screens/_resourses/navigation.dart';
import 'package:social_3c/screens/layout/view.dart';
import 'package:social_3c/services/local_database.dart';

import 'auth/login.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final myId = CacheHelper.getData(key: "myId");

  @override
  void initState() {
    if (myId != null) {
      context.read<AuthCtrl>().getMyData(myId);
    }
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then(
      (value) {
        if (myId != null) {
          toAndReplacement(context, const LayoutView());
        } else {
          toAndReplacement(context, const LoginView());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Text("my app logo"),
            Spacer(),
            Text("@powered by Mohamed Ashraf"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
