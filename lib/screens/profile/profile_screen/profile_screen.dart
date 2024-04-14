import 'package:apniseva/controller/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../profile_sections/profile_app_bar.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);

    return Scaffold(
      appBar: const PrimaryAppBar(
        title: 'My Profile',
      ),
      body: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const CircleAvatar(
                radius: 55,
                // backgroundImage: NetworkImage(DashStrings.serviceImg),
                backgroundImage:
                    AssetImage('assets/images/appLauncherIcon.jpeg'),
              ),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'User ID: ',
                  style: Theme.of(context).textTheme.headlineSmall),
              TextSpan(
                  text: profileController
                      .userModel.value.messages!.status!.userId,
                  style: Theme.of(context).textTheme.titleLarge),
            ])),
            SizedBox(height: height * 0.01),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Name: ',
                  style: Theme.of(context).textTheme.headlineSmall),
              TextSpan(
                  text: profileController
                      .userModel.value.messages!.status!.fullname,
                  style: Theme.of(context).textTheme.titleLarge),
            ])),
            SizedBox(height: height * 0.01),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Email: ',
                  style: Theme.of(context).textTheme.headlineSmall),
              TextSpan(
                  text:
                      profileController.userModel.value.messages!.status!.email,
                  style: Theme.of(context).textTheme.titleLarge),
            ])),
            SizedBox(
              height: height * 0.01,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Mobile No: ',
                  style: Theme.of(context).textTheme.headlineSmall),
              TextSpan(
                  text: profileController
                      .userModel.value.messages!.status!.contact,
                  style: Theme.of(context).textTheme.titleLarge),
            ])),
            SizedBox(
              height: height * 0.03,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const EditProfileScreen())?.then((value) {
            setState(() {});
          });
        },
        label: const Row(
          children: [
            Text('Edit Profile'),
            SizedBox(width: 5),
            Icon(
              Remix.pencil_fill,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
