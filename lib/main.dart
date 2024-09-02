import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_3c/services/local_storage.dart';

import 'app/app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CacheHelper.init();
  runApp(const MyApp());
}

//todo like comment search firebase chat ui
