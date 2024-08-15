import 'package:flutter/material.dart';

import '../assets_path/icon_broken.dart';

enum CaseState {
  loading,
  error,
  empty,
}

class LoadingErrorEmptyView extends StatelessWidget {
  const LoadingErrorEmptyView({
    required this.state,
    required this.message,
    this.child,
    super.key,
  });

  final CaseState state;
  final String message;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (state == CaseState.loading) {
      return Center(
        child: Column(
          children: [
            const Spacer(),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20.0),
                    Text("Get $message Loading..."),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (child != null) child!,
          ],
        ),
      );
    }
    if (state == CaseState.error) {
      return Center(
        child: Column(
          children: [
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 150,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Error When Getting\n$message",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Spacer(),
            if (child != null) child!,
          ],
        ),
      );
    }

    return Center(
      child: Column(
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                IconBroken.chat,
                color: Colors.grey,
                size: 150,
              ),
              const SizedBox(height: 20.0),
              Text(
                "No $message yet!\nStart add one..",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (child != null) child!,
        ],
      ),
    );
  }
}
