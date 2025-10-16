import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mychat/screens/splash_screen.dart';
import 'package:mychat/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



// global object for accessing device size
late Size mq;




void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // fix portrait orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]
  ).then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  }
  );


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

