import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/bottom_nav_bar.dart';
import '../../auth/screens/registration_screen.dart';
import '../widgets/spalsh_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      checkLogin();
    });
    super.initState();
  }

  checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userID = pref.getString(ApiStrings.userID);
    bool isGuest = pref.getBool('isGuest') ?? false;

    if (userID != null || isGuest) {
      Get.offAll(() => const BottomNavBar());
    } else {
      Get.offAll(() => const RegistrationScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Image.asset(SplashStrings.apniSevaLogo),
        ),
      ),
    );
  }
}
