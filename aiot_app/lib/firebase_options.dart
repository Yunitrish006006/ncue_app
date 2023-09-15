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
    apiKey: 'AIzaSyAPzVC7xfFn8fyBBjVzul2Qtx7RJIW69EI',
    appId: '1:117149850724:web:d3ae9dd00c670de513d371',
    messagingSenderId: '117149850724',
    projectId: 'ncueapp',
    authDomain: 'ncueapp.firebaseapp.com',
    databaseURL: 'https://ncueapp-default-rtdb.firebaseio.com',
    storageBucket: 'ncueapp.appspot.com',
    measurementId: 'G-PX9R2LDGW5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoy6rA6aun794_rhtAM0g1MFK3KXCMhfo',
    appId: '1:117149850724:android:fae1f79cb7a6361013d371',
    messagingSenderId: '117149850724',
    projectId: 'ncueapp',
    databaseURL: 'https://ncueapp-default-rtdb.firebaseio.com',
    storageBucket: 'ncueapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVBc0bQry4i0EqRs0JxbnTaCV8EaEJj9g',
    appId: '1:117149850724:ios:e9024e2e66190e9513d371',
    messagingSenderId: '117149850724',
    projectId: 'ncueapp',
    databaseURL: 'https://ncueapp-default-rtdb.firebaseio.com',
    storageBucket: 'ncueapp.appspot.com',
    androidClientId: '117149850724-d0apk5n93oebga46tr81751p60ekl8c1.apps.googleusercontent.com',
    iosClientId: '117149850724-tasscf51vbi1j91t0ti23cdkt1d5gq4n.apps.googleusercontent.com',
    iosBundleId: 'com.example.ncueApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAVBc0bQry4i0EqRs0JxbnTaCV8EaEJj9g',
    appId: '1:117149850724:ios:b49125bf4010497613d371',
    messagingSenderId: '117149850724',
    projectId: 'ncueapp',
    databaseURL: 'https://ncueapp-default-rtdb.firebaseio.com',
    storageBucket: 'ncueapp.appspot.com',
    androidClientId: '117149850724-d0apk5n93oebga46tr81751p60ekl8c1.apps.googleusercontent.com',
    iosClientId: '117149850724-rjd76oj6sfk7n1dk9uptikmiorm99vkb.apps.googleusercontent.com',
    iosBundleId: 'com.example.ncueApp.RunnerTests',
  );
}
