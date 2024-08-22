import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_3c/ctrl/auth_ctrl.dart';
import 'package:social_3c/screens/auth/register.dart';

import '../_resourses/navigation.dart';
import '../layout/view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCtrl, AuthStates>(
      listener: (context, state) {
        if (state is AuthSuccessAndGettingDataState) {
          toAndFinish(context, const LayoutView());
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCtrl>();
        return Scaffold(
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: cubit.emailCtrl,
                  decoration: InputDecoration(
                    hintText: 'Username/email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: cubit.passwordCtrl,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                            cubit.isPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.green),
                        onPressed: () {
                          cubit.showPassword();
                        },
                      )),
                  obscureText: cubit.isPassword,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cubit.login,
                    child: const Text('LOGIN'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        toAndReplacement(context, const RegisterView());
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}
