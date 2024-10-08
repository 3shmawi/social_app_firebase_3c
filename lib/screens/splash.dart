import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/screens/_resources/assets_path/assets_manager.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/auth/login_view.dart';
import 'package:social_3c/screens/layout/layout_view.dart';
import 'package:social_3c/services/local_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final myId = CacheHelper.getData(key: "myId");

  @override
  void initState() {
    if (myId != null) {
      context.read<AuthCtrl>().getProfileData(myId);
    }
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (myId == null) {
        toAndReplacement(context, const LoginView());
      } else {
        toAndReplacement(context, const LayoutView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              AssetsManager.logo,
              height: 300,
              width: 300,
            ),
            const Spacer(),
            Text(
              "MYM App",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900),
            ),
            Text(
              "powered by 3c",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
