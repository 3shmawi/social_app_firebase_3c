import 'package:flutter/material.dart';
import 'package:social_3c/screens/page2.dart';
import 'package:social_3c/screens/page3.dart';

import '_resources/shared/navigation.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page 1"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                toAndReplacement(context, Page2());
              },
              child: Text("page2"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                toAndFinish(context, Page3());
              },
              child: Text("page3"),
            ),
          ],
        ),
      ),
    );
  }
}
