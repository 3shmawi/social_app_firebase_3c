import 'package:flutter/material.dart';

toPage(BuildContext context, Widget page) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

toAndReplacement(BuildContext context, Widget page) {
  return Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

toAndFinish(BuildContext context, Widget page) {
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => page,
    ),
    (route) => false,
  );
}
