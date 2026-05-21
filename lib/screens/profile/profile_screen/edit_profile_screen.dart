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
  final profileController = Get.find<AuthController>();

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

    if (name.isEmpty || email.isEmpty || phoneNumber.isEmpty) {
      Get.snackbar('Required', 'Please fill all fields',
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
      return;
    }

    if (profileController.userModel.value.messages?.status?.userId == null) {
      Get.snackbar('Error', 'User Session expired. Please login again.',
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
        .then((success) async {
      Navigator.pop(context); // Close loading dialog
      if (success) {
        await profileController.getUserData(); // Refresh local data
        Get.snackbar('Success', 'Profile updated successfully',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context); // Return to profile screen
        });
      } else {
        Get.snackbar('Error', 'Failed to update profile. Check your connection.',
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red);
      }
    }).catchError((e) {
      Navigator.pop(context);
      Get.snackbar('Error', 'An unexpected error occurred',
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
    });
  }
}
