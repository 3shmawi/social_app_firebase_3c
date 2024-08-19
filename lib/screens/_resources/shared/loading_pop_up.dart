import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../assets_path/icon_broken.dart';

class AppCasesPopUp extends StatelessWidget {
  const AppCasesPopUp({
    required this.state,
    this.message = ",,,,,,,",
    this.icon = IconBroken.scan,
    super.key,
  });

  final AppCases state;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AppCases.empty:
        {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.grey.shade400,
                  size: 150,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }
      case AppCases.loading:
        {
          return const Center(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.green,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      case AppCases.failure:
        {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.info,
                  color: Colors.red,
                  size: 150,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        }
    }
  }
}

enum AppCases { loading, failure, empty }
