// Auto-generated equivalent of FlutterFire CLI output.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform not configured for Firebase yet.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase not configured for ${defaultTargetPlatform.name}.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAO7_KB-5PiBXnctSrDMyZMbJkw3p1Pjqs',
    appId: '1:631904183951:android:0d3e740a6504d6902432fa',
    messagingSenderId: '631904183951',
    projectId: 'momrise-cca9c',
    storageBucket: 'momrise-cca9c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBanADYfTCXbs827kEeQlgG-pND6zm-3xc',
    appId: '1:631904183951:ios:d74e3633017f8bb62432fa',
    messagingSenderId: '631904183951',
    projectId: 'momrise-cca9c',
    storageBucket: 'momrise-cca9c.firebasestorage.app',
    iosBundleId: 'com.momrise.momrise',
  );
}
