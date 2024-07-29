import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/controller/auth_ctrl.dart';
import 'package:social_3c/screens/_resources/shared/navigation.dart';
import 'package:social_3c/screens/auth/login_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

//services
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCtrl, AuthStates>(
      builder: (context, state) {
        final cubit = context.read<AuthCtrl>();
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 57,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(cubit.myData!.imgUrl),
                  ),
                ),
                Text(
                  cubit.myData!.name,
                  style: const TextStyle(fontSize: 24),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    context.read<AuthCtrl>().logout().then((value) {
                      if (value) {
                        toAndFinish(context, const LoginView());
                      }
                    });
                  },
                  child: const Text(
                    "LOGOUT",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
