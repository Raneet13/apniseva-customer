import 'package:apniseva/controller/auth_controller/auth_controller.dart';
import 'package:apniseva/utils/buttons.dart';
import 'package:apniseva/utils/color.dart';
import 'package:apniseva/utils/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final profileController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    // Initialize with current user data
    final userStatus = profileController.userModel.value.messages?.status;
    _nameController.text = userStatus?.fullname ?? '';
    _emailController.text = userStatus?.email ?? '';
    _phoneController.text = userStatus?.contact ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Remix.arrow_left_s_line, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/appLauncherIcon.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: GestureDetector(
                //     onTap: () {
                //       // Handle image pick
                //       // profileController.pickImage();
                //     },
                //     child: Container(
                //       padding: const EdgeInsets.all(8),
                //       decoration: BoxDecoration(
                //         color: primaryColor,
                //         shape: BoxShape.circle,
                //         border: Border.all(color: Colors.white, width: 2),
                //       ),
                //       child: const Icon(
                //         Remix.camera_line,
                //         color: Colors.white,
                //         size: 18,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 32),
            _buildInputGroup("Full Name", _nameController, Remix.user_line,
                TextInputType.name),
            const SizedBox(height: 20),
            _buildInputGroup("Email Address", _emailController, Remix.mail_line,
                TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildInputGroup("Phone Number", _phoneController, Remix.phone_line,
                TextInputType.phone),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputGroup(String label, TextEditingController controller,
      IconData icon, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: type,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.blueGrey.shade900,
            ),
            decoration: InputDecoration(
              hintText: "Enter your $label",
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.blueGrey.shade300,
              ),
              prefixIcon: Icon(icon, color: Colors.blueGrey.shade400, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phoneNumber = _phoneController.text.trim();

    if (name.isEmpty) {
      Get.snackbar('Required', 'Please enter your name',
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
      return;
    }
    if (email.isEmpty) {
      Get.snackbar('Required', 'Please enter your email',
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
      return;
    }
    if (phoneNumber.isEmpty) {
      Get.snackbar('Required', 'Please enter your phone number',
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          Center(child: CircularProgressIndicator(color: primaryColor)),
    );

    profileController
        .updateUserData(name, email, phoneNumber)
        .then((value) async {
      Navigator.pop(context); // Close loading dialog
      if (value) {
        await profileController.getUserData();
        Get.snackbar('Success', 'Your profile has been updated.',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green);
        Navigator.pop(context); // Go back to profile
      } else {
        Get.snackbar('Error', 'Failed to update profile. Please try again.',
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red);
      }
    });
  }
}
