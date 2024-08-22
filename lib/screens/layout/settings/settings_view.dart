import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/auth_ctrl.dart';
import 'package:social_3c/screens/_resourses/navigation.dart';
import 'package:social_3c/screens/auth/login.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          context.read<AuthCtrl>().logout().then((v) {
            toAndFinish(context, const LoginView());
          });
        },
        child: const Text('LOGOUT'),
      ),
    );
  }
}
