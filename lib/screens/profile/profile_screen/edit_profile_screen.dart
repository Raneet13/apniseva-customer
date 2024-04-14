import 'package:apniseva/utils/buttons.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../../../controller/auth_controller/auth_controller.dart';
import '../../../utils/input_field.dart';
import '../profile_sections/profile_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late double width = MediaQuery.of(context).size.width;
  late double height = MediaQuery.of(context).size.height -
      (MediaQuery.of(context).padding.top +
          MediaQuery.of(context).padding.bottom);
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final profileController = Get.put(AuthController());
  @override
  void initState() {
    _nameController.text =
        profileController.userModel.value.messages!.status!.fullname ?? '';
    _emailController.text =
        profileController.userModel.value.messages!.status!.email ?? '';
    _phoneController.text =
        profileController.userModel.value.messages!.status!.contact ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(
        title: 'Edit Profile',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: badges.Badge(
                // badgeColor: primaryColor,
                position: badges.BadgePosition.custom(bottom: 2, end: 10),
                badgeContent: InkWell(
                  onTap: () {},
                  child: const Icon(
                    Remix.pencil_fill,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 55,
                  //backgroundImage: NetworkImage(DashStrings.serviceImg),
                  backgroundImage:
                      AssetImage('assets/images/appLauncherIcon.jpeg'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Upload Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              'Name',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextInput(
              controller: _nameController,
              keyboardType: TextInputType.name,
              hintText: 'Name',
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              'Email',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextInput(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: "xyz@gmail.com",
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              'Phone No',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextInput(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              hintText: "1234567890",
            ),
            const Spacer(),
            PrimaryButton(
              width: width,
              height: 47,
              onPressed: () {
                final name = _nameController.text.trim();
                final email = _emailController.text.trim();
                final phoneNumber = _phoneController.text.trim();
                if (name.isEmpty) {
                  Get.snackbar('Error', 'Name can not be empty');
                  return;
                }
                if (email.isEmpty) {
                  Get.snackbar('Error', 'Email can not be empty');
                  return;
                }

                if (phoneNumber.isEmpty) {
                  Get.snackbar('Error', 'Phone number can not be empty');
                  return;
                }
                showDialog(
                  context: context,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
                profileController
                    .updateUserData(name, email, phoneNumber)
                    .then((value) async {
                  if (value) {
                    await profileController.getUserData();
                    Get.snackbar('Successful', 'Profile updated successfully');
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);

                    Get.snackbar('Error', 'Something went wrong');
                  }
                });
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
