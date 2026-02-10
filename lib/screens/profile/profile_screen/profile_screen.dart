import 'package:apniseva/screens/auth/controller/auth_controller.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'My Profile',
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
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
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
                        // TODO: Use NetworkImage when available or handle nulls
                        image: AssetImage('assets/images/appLauncherIcon.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.all(4),
                  //   padding: const EdgeInsets.all(6),
                  //   decoration: BoxDecoration(
                  //     color: primaryColor,
                  //     shape: BoxShape.circle,
                  //     border: Border.all(color: Colors.white, width: 2),
                  //   ),
                  //   child: const Icon(
                  //     Remix.shield_check_fill,
                  //     color: Colors.white,
                  //     size: 14,
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
                  profileController
                          .userModel.value.messages?.status?.fullname ??
                      "User",
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey.shade900,
                  ),
                )),
            const SizedBox(height: 8),
            Obx(() => Text(
                  profileController.userModel.value.messages?.status?.email ??
                      "user@example.com",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.blueGrey.shade500,
                  ),
                )),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Obx(() => Column(
                    children: [
                      _buildProfileItem(
                        icon: Remix.user_3_line,
                        title: "Full Name",
                        value: profileController
                                .userModel.value.messages?.status?.fullname ??
                            "",
                      ),
                      const Divider(height: 32, thickness: 1),
                      _buildProfileItem(
                        icon: Remix.mail_line,
                        title: "Email Address",
                        value: profileController
                                .userModel.value.messages?.status?.email ??
                            "",
                      ),
                      const Divider(height: 32, thickness: 1),
                      _buildProfileItem(
                        icon: Remix.phone_line,
                        title: "Phone Number",
                        value: profileController
                                .userModel.value.messages?.status?.contact ??
                            "",
                      ),
                      const Divider(height: 32, thickness: 1),
                      _buildProfileItem(
                        icon: Remix.fingerprint_line,
                        title: "User ID",
                        value: profileController
                                .userModel.value.messages?.status?.userId ??
                            "",
                        isCopyable: true,
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const EditProfileScreen())?.then((value) {
            // Force refresh if needed
            profileController.getUserData();
          });
        },
        backgroundColor: primaryColor,
        elevation: 4,
        icon: const Icon(Remix.pencil_line, color: Colors.white, size: 20),
        label: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    bool isCopyable = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.blueGrey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.blueGrey.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (isCopyable)
          IconButton(
            onPressed: () {
              // Add clipboard functionality here if needed
            },
            icon: Icon(Remix.file_copy_line,
                size: 18, color: Colors.blueGrey.shade300),
          ),
      ],
    );
  }
}
