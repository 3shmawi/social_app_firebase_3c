import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/auth/login_view.dart';
import 'package:social_3c/services/local_storage.dart';

import '../../_resources/shared/toast.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCtrl, AuthStates>(
      builder: (context, state) {
        final cubit = context.read<AuthCtrl>();
        return Center(
          child: Column(
            children: [
              Text(
                cubit.myData!.name,
                style: const TextStyle(fontSize: 24),
              ),
              TextButton(
                onPressed: () {
                  cubit.logout().then((value) {
                    AppToast.success("Logged out successfully");
                    CacheHelper.removeData(key: "myId");
                    toAndFinish(context, const LoginView());
                  }).catchError((error) {
                    AppToast.error("Failed to log out");
                  });
                },
                child: const Text("LOGOUT"),
              ),
            ],
          ),
        );
      },
    );
  }
}
