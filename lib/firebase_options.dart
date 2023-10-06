// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBVNVbjcW2R_T7hNM1LEJaEMTizY_YSx1Q',
    appId: '1:580609905087:web:6566b137914659d120d10a',
    messagingSenderId: '580609905087',
    projectId: 'photostatus-2f31f',
    authDomain: 'photostatus-2f31f.firebaseapp.com',
    storageBucket: 'photostatus-2f31f.appspot.com',
    measurementId: 'G-JB8TQMMY58',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBr7TK1RKXbnTi0P6okw1OdFt-GbcRGXh0',
    appId: '1:580609905087:android:e42359151c82c67f20d10a',
    messagingSenderId: '580609905087',
    projectId: 'photostatus-2f31f',
    storageBucket: 'photostatus-2f31f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcfW9PbxSiy5o1-rX4WopVsb0d7WOODpE',
    appId: '1:580609905087:ios:d754280f70e4d22320d10a',
    messagingSenderId: '580609905087',
    projectId: 'photostatus-2f31f',
    storageBucket: 'photostatus-2f31f.appspot.com',
    iosBundleId: 'com.universe.photostatus',
  );
}