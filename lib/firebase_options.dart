//Her bir platform için FirebaseOptions nesnesi oluşturulur ve gerekli alanlar (apiKey, appId, messagingSenderId, projectId, storageBucket) belirtilir. 
//iOS ve macOS için ekstra alanlar (iosClientId, iosBundleId) da belirtilir.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform; 


class DefaultFirebaseOptions {
  //DefaultFirebaseOptions sınıfı, Firebase yapılandırma seçeneklerini tutan ve farklı platformlarda kullanılmak üzere seçenekleri sağlayan bir sınıftır.
  static FirebaseOptions get currentPlatform {
    //Bir static getter metodu tanımlanır. Bu metot, mevcut platforma bağlı olarak ilgili Firebase yapılandırma seçeneklerini döndürür.
    if (kIsWeb) {
      //Flutter'ın web platformunda çalışıp çalışmadığını belirler. 
      //Eğer kIsWeb true ise, web platformu için yapılandırma seçenekleri döndürülür.
      return web;
    }
    switch (defaultTargetPlatform) {
      // Flutter uygulamasının çalıştığı platformu belirler.
      //switch ifadesi kullanarak, defaultTargetPlatform değerine bağlı olarak ilgili yapılandırma seçenekleri döndürülür.
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
    apiKey: 'AIzaSyBk54XkmN1rFBB3oIHZXgMfGwaUUGA5Wac',
    appId: '1:1075063099490:web:3859c2baf57efa3b68013b',
    messagingSenderId: '1075063099490',
    projectId: 'face-recognition-app-aefd1',
    authDomain: 'face-recognition-app-aefd1.firebaseapp.com',
    storageBucket: 'face-recognition-app-aefd1.appspot.com',
    measurementId: 'G-3HCX5SBXET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuzp1FTGtBTD0ia_oitlMat9XD1z7Yqmk',
    appId: '1:1075063099490:android:347c0099c676a63868013b',
    messagingSenderId: '1075063099490',
    projectId: 'face-recognition-app-aefd1',
    storageBucket: 'face-recognition-app-aefd1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPEyJGIMWt6ZnYBPW1eK-kS2zwdnnWshc',
    appId: '1:1075063099490:ios:635e48566d801c0268013b',
    messagingSenderId: '1075063099490',
    projectId: 'face-recognition-app-aefd1',
    storageBucket: 'face-recognition-app-aefd1.appspot.com',
    iosClientId: '1075063099490-gojf5l0u1jq0q3e8032klnm2qnktqsk8.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFaceRecognationApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPEyJGIMWt6ZnYBPW1eK-kS2zwdnnWshc',
    appId: '1:1075063099490:ios:ab3db0e64aff761e68013b',
    messagingSenderId: '1075063099490',
    projectId: 'face-recognition-app-aefd1',
    storageBucket: 'face-recognition-app-aefd1.appspot.com',
    iosClientId: '1075063099490-l1o394ei50otjcbhh6ifam6p3v2vh645.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFaceRecognationApp.RunnerTests',
  );
}
