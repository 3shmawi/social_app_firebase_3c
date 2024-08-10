import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/auth/login_view.dart';

import '../../_resources/assets_path/icon_broken.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCtrl, AuthStates>(
      listener: (context, state) {
        if (state is LogoutState) {
          toAndFinish(context, const LoginView());
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCtrl>();

        final myData = cubit.myData;
        if (myData == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  IconBroken.user1,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'No User Data Founded.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Please Create One Or Login To You Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 20.0),
                OutlinedButton(
                  onPressed: () {
                    toAndFinish(context, const LoginView());
                  },
                  child: const Text("to Login page"),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 83,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage(myData.imgUrl),
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  myData.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  myData.email,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    context.read<AuthCtrl>().logout();
                  },
                  child: const Text("LOGOUT"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
