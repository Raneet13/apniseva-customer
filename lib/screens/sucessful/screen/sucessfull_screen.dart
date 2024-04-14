import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/bottom_nav_bar.dart';

class SuccessfulScreen extends StatefulWidget {
  const SuccessfulScreen({Key? key}) : super(key: key);

  @override
  State<SuccessfulScreen> createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {
  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 2), (){
    //   Get.to(()=> const BottomNavBar());
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Get.to(() => const BottomNavBar());
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Thank you for booking our service',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'We have received your request',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const BottomNavBar());
                  },
                  child: Text(
                    "RETURN TO HOME",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
