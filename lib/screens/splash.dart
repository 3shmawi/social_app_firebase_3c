import 'package:flutter/material.dart';
import 'package:social_3c/screens/_resources/assets_path/assets_manager.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/auth/login_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      toAndReplacement(context, const LoginView());
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
