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
    apiKey: 'AIzaSyCCIdh3jfxmoZyO3cAyh7tetYCoZg96vsk',
    appId: '1:1063584916764:web:375b3a1ca943dc99e3c6d9',
    messagingSenderId: '1063584916764',
    projectId: 'round3bnaoflutter',
    authDomain: 'round3bnaoflutter.firebaseapp.com',
    storageBucket: 'round3bnaoflutter.appspot.com',
    measurementId: 'G-RGR85LFS5H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtdulv2dshZglNP2zTIve4eWtda74Jf3Y',
    appId: '1:1063584916764:android:7c5962cf87b51899e3c6d9',
    messagingSenderId: '1063584916764',
    projectId: 'round3bnaoflutter',
    storageBucket: 'round3bnaoflutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtFOk7ooBUVCdCCZKuOHo41GtD8-yE84Y',
    appId: '1:1063584916764:ios:e8242890af129d3ae3c6d9',
    messagingSenderId: '1063584916764',
    projectId: 'round3bnaoflutter',
    storageBucket: 'round3bnaoflutter.appspot.com',
    iosClientId: '1063584916764-bos3mgvms40bqirl3h3u8k3138nf7n8m.apps.googleusercontent.com',
    iosBundleId: 'com.example.round3BanaoFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtFOk7ooBUVCdCCZKuOHo41GtD8-yE84Y',
    appId: '1:1063584916764:ios:e8242890af129d3ae3c6d9',
    messagingSenderId: '1063584916764',
    projectId: 'round3bnaoflutter',
    storageBucket: 'round3bnaoflutter.appspot.com',
    iosClientId: '1063584916764-bos3mgvms40bqirl3h3u8k3138nf7n8m.apps.googleusercontent.com',
    iosBundleId: 'com.example.round3BanaoFlutter',
  );
}
