import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Welcome to Flutter App!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
