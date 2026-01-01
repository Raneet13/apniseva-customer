import 'package:apniseva/controller/address_controller/address_controller.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/location_controller/location_controller.dart';
import '../../../model/cart_model/cart_detail_model/cart_details_model.dart';
import '../../../utils/api_strings/api_strings.dart';
import '../widget/address_strings.dart';

class AddressFormScreen extends StatefulWidget {
  final int apiCall;
  final AddressDatum? addressData;
  const AddressFormScreen({
    Key? key,
    required this.apiCall,
    this.addressData,
  }) : super(key: key);

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen>
    with SingleTickerProviderStateMixin {
  String? getLoc;

  final formKey = GlobalKey<FormState>();
  final addressController = Get.put(AddressController());
  final locController = Get.put(LocationController());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    Future.delayed(Duration.zero, () {
      locController.getLoc();
    });
    if (widget.apiCall == 1) {
      if (widget.addressData != null) {
        addressController.firstName.text = widget.addressData!.firstName ?? '';
        addressController.lastName.text = widget.addressData!.lastName ?? '';
        addressController.email.text = widget.addressData!.email ?? '';
        addressController.phone.text = widget.addressData!.number ?? '';
        addressController.address1.text = widget.addressData!.address1 ?? '';
        addressController.address2.text = widget.addressData!.adress2 ?? '';
        addressController.pinCode.text = widget.addressData!.pincode ?? '';
        addressController.state.text = widget.addressData!.state ?? '';
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    addressController.firstName.text = '';
    addressController.lastName.text = '';
    addressController.email.text = "";
    addressController.phone.text = "";
    addressController.address1.text = '';
    addressController.address2.text = '';
    addressController.pinCode.text = '';
    addressController.state.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Remix.arrow_left_line,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.apiCall == 1 ? "Edit Address" : "Add New Address",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information Section
                  _buildSectionCard(
                    title: "Personal Information",
                    icon: Remix.user_line,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildModernTextField(
                              controller: addressController.firstName,
                              label: AddressStrings.fFirstName,
                              hint: 'Suresh',
                              icon: Remix.user_3_line,
                              validator: (value) {
                                if (addressController.firstName.text.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildModernTextField(
                              controller: addressController.lastName,
                              label: AddressStrings.fLastName,
                              hint: 'Kumar',
                              icon: Remix.user_3_line,
                              validator: (value) {
                                if (addressController.lastName.text.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        controller: addressController.email,
                        label: AddressStrings.fEmail,
                        hint: 'sureshkumar@gmail.com',
                        icon: Remix.mail_line,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (addressController.email.text.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(value!)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        controller: addressController.phone,
                        label: AddressStrings.fPhone,
                        hint: '1234567890',
                        icon: Remix.phone_line,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (addressController.phone.text.isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value!) ||
                              value.length != 10) {
                            return 'Enter a valid 10-digit number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Address Details Section
                  _buildSectionCard(
                    title: "Address Details",
                    icon: Remix.map_pin_line,
                    children: [
                      _buildModernTextField(
                        controller: addressController.address1,
                        label: AddressStrings.fAddress1,
                        hint: 'House No., Building Name',
                        icon: Remix.home_line,
                        maxLines: 3,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (addressController.address1.text.isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        controller: addressController.address2,
                        label: AddressStrings.fAddress2,
                        hint: 'Road Name, Area, Colony (Optional)',
                        icon: Remix.road_map_line,
                        maxLines: 3,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildCityDropdown(width),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        controller: addressController.pinCode,
                        label: AddressStrings.fPinCode,
                        hint: '751016',
                        icon: Remix.map_pin_2_line,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        validator: (value) {
                          if (addressController.pinCode.text.isEmpty) {
                            return 'Pin code is required';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value!) ||
                              value.length != 6) {
                            return 'Enter a valid 6-digit pin code';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(() {
            return Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: addressController.isLoading.value
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            if (widget.apiCall == 0) {
                              debugPrint("Add Address API heated");
                              Future.delayed(Duration.zero, () {
                                addressController.addAddress();
                              });
                              Get.back();
                            } else if (widget.apiCall == 1) {
                              debugPrint("Updated Address");
                              Future.delayed(Duration.zero, () {
                                addressController.updateAddress();
                              });
                              Get.back();
                            }
                          } else {
                            Get.snackbar(
                              'Address',
                              "Please fill all required fields",
                              colorText: Colors.white,
                              backgroundColor: Colors.red.withOpacity(0.8),
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                            );
                          }
                        },
                  child: Center(
                    child: addressController.isLoading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Remix.save_line,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.apiCall == 1
                                    ? 'UPDATE ADDRESS'
                                    : 'SAVE ADDRESS',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(icon, color: primaryColor, size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            counterText: '',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityDropdown(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AddressStrings.fCity,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: locController.isLoading.value == true
                ? Container(
                    height: 54,
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    ),
                  )
                : DropdownButtonFormField<String>(
                    value: getLoc,
                    hint: Text(
                      'Choose your Location',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (getLoc == null) {
                        return 'Please select a city';
                      }
                      return null;
                    },
                    isExpanded: true,
                    icon: Icon(Remix.arrow_down_s_line, color: primaryColor),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Remix.map_pin_line,
                          color: primaryColor, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      errorStyle: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.red,
                      ),
                    ),
                    dropdownColor: Colors.white,
                    items: locController
                        .locationModel.value.messages?.status!.city!
                        .map((items) {
                      return DropdownMenuItem<String>(
                        onTap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.setString(
                              ApiStrings.cityID, items.cityId.toString());
                          preferences.setString(
                              ApiStrings.cityName, items.cityName.toString());
                        },
                        value: items.cityName,
                        child: Text(
                          items.cityName!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        getLoc = newValue!;
                      });
                    },
                  ),
          );
        }),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final String title;
  const Header({Key? key, this.title = 'TITLE'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
