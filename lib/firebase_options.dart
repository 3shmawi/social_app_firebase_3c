// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBXYhVc-V7oTZvCCxB7xr0cHFqfJY8BPNA',
    appId: '1:360287151468:web:8f886df4b1651af4213f49',
    messagingSenderId: '360287151468',
    projectId: 'social-app-2403b',
    authDomain: 'social-app-2403b.firebaseapp.com',
    storageBucket: 'social-app-2403b.appspot.com',
    measurementId: 'G-4GHGH5DP7S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_PAmQ9g5TaxgHKLZuObKtdGshdTKZduU',
    appId: '1:360287151468:android:e5e62dfca28573d7213f49',
    messagingSenderId: '360287151468',
    projectId: 'social-app-2403b',
    storageBucket: 'social-app-2403b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3UURgqnp_tFRt7U_L8xRvhvYUSLXplzI',
    appId: '1:360287151468:ios:73a67f6450320f0f213f49',
    messagingSenderId: '360287151468',
    projectId: 'social-app-2403b',
    storageBucket: 'social-app-2403b.appspot.com',
    iosBundleId: 'com.ashmawi.social3c',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC3UURgqnp_tFRt7U_L8xRvhvYUSLXplzI',
    appId: '1:360287151468:ios:73a67f6450320f0f213f49',
    messagingSenderId: '360287151468',
    projectId: 'social-app-2403b',
    storageBucket: 'social-app-2403b.appspot.com',
    iosBundleId: 'com.ashmawi.social3c',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXYhVc-V7oTZvCCxB7xr0cHFqfJY8BPNA',
    appId: '1:360287151468:web:62cc2ba781375026213f49',
    messagingSenderId: '360287151468',
    projectId: 'social-app-2403b',
    authDomain: 'social-app-2403b.firebaseapp.com',
    storageBucket: 'social-app-2403b.appspot.com',
    measurementId: 'G-M703PDEJ2C',
  );

}