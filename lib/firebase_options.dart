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
        return macos;
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
    apiKey: 'AIzaSyANcYl0O1fv01oD_kag8cGM5h8535AtELE',
    appId: '1:456531748660:web:b52a61061928e9388ae761',
    messagingSenderId: '456531748660',
    projectId: 'bored-board-57d27',
    authDomain: 'bored-board-57d27.firebaseapp.com',
    storageBucket: 'bored-board-57d27.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEiBThDqmA2yHBFVkHj_g4UdRVnqJbs0A',
    appId: '1:456531748660:android:8f3e5ae095bcaf098ae761',
    messagingSenderId: '456531748660',
    projectId: 'bored-board-57d27',
    storageBucket: 'bored-board-57d27.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTK2feUVoOESq1Meo_XyTb2siwTxjOo78',
    appId: '1:456531748660:ios:5e345e4f019d7ec58ae761',
    messagingSenderId: '456531748660',
    projectId: 'bored-board-57d27',
    storageBucket: 'bored-board-57d27.appspot.com',
    iosClientId: '456531748660-1gei2puq7biuatm7tq9d366vbp1oht78.apps.googleusercontent.com',
    iosBundleId: 'com.example.boredBoard',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTK2feUVoOESq1Meo_XyTb2siwTxjOo78',
    appId: '1:456531748660:ios:5e345e4f019d7ec58ae761',
    messagingSenderId: '456531748660',
    projectId: 'bored-board-57d27',
    storageBucket: 'bored-board-57d27.appspot.com',
    iosClientId: '456531748660-1gei2puq7biuatm7tq9d366vbp1oht78.apps.googleusercontent.com',
    iosBundleId: 'com.example.boredBoard',
  );
}