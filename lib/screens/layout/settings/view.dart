import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            context.read<AuthCtrl>().myData!.name,
            style: const TextStyle(fontSize: 24),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthCtrl>().logout();
            },
            child: Text("LOGOUT"),
          ),
        ],
      ),
    );
  }
}
