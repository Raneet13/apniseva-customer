import 'package:apniseva/screens/cart/cart_controller/cart_controller.dart';
import 'package:apniseva/utils/color.dart';
import 'package:apniseva/utils/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';

import '../../address/screen/address_screen.dart';

class CartOrderScheduleTotal extends StatefulWidget {
  const CartOrderScheduleTotal({
    Key? key,
  }) : super(key: key);

  @override
  State<CartOrderScheduleTotal> createState() => _CartOrderScheduleTotalState();
}

class _CartOrderScheduleTotalState extends State<CartOrderScheduleTotal> {
  final cartController = Get.put(CartController());

  @override
  void initState() {
    cartController.firstName;
    cartController.lastName;
    cartController.number;
    cartController.email;
    cartController.address1;
    cartController.address2;
    cartController.cityName;
    cartController.state;
    cartController.pinCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Section
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Remix.map_pin_2_line,
                          color: primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Service Address',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey.shade800,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.to(() =>
                                const AddressScreen(isSelectingFromCart: true))
                            ?.then((value) {
                          cartController.getCartData();
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        backgroundColor: primaryColor.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        cartController.addressID == null ? "Add" : "Change",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Address Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: cartController.addressID == null
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.grey.shade100,
                              style: BorderStyle.solid),
                        ),
                        child: Row(
                          children: [
                            Icon(Remix.error_warning_line,
                                color: Colors.orange.shade300, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "No address selected. Please add a service location.",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.blueGrey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${cartController.firstName} ${cartController.lastName}",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${cartController.address1}, ${cartController.address2}, ${cartController.cityName}, ${cartController.state} - ${cartController.pinCode}",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey.shade500,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Remix.phone_line,
                                  size: 14, color: Colors.blueGrey.shade300),
                              const SizedBox(width: 6),
                              Text(
                                cartController.number ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFF8F9FB)),

              // Schedule Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Remix.calendar_check_line,
                          color: Colors.green.shade600, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Schedule Service',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey.shade800,
                      ),
                    ),
                  ],
                ),
              ),

              // Schedule Content (Inputs)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  children: [
                    // Date Picker
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.blue.shade100.withOpacity(0.5)),
                        ),
                        child: PickerInputField(
                          pick: 'Date',
                          hintText: 'Select Date',
                          controller: cartController.dateController,
                          prefixIcon: Remix.calendar_event_line,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Time Picker
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.orange.shade100.withOpacity(0.5)),
                        ),
                        child: PickerInputField(
                          pick: 'Time',
                          hintText: 'Select Time',
                          controller: cartController.timeController,
                          prefixIcon: Remix.time_line,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
