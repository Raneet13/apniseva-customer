import 'package:apniseva/firebase_options.dart';
import 'package:apniseva/screens/splash_screen/screens/splash_screen.dart';

import 'package:apniseva/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

BuildContext? testContext;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}


// I coment search of //""SearchField()""//  yu must it change and show as it is revious
//DashAppBar( ) screen chage cart menu hich arrenged on the navigation bar