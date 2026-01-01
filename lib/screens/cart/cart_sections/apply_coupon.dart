import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';

import '../../../controller/cart_controller/cart_controller.dart';

class CartApplyCoupon extends StatefulWidget {
  const CartApplyCoupon({
    Key? key,
  }) : super(key: key);

  @override
  State<CartApplyCoupon> createState() => _CartApplyCouponState();
}

class _CartApplyCouponState extends State<CartApplyCoupon> {
  final couponController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = couponController.couponDataModel.value.messages?.status;
      final totalAmount = status?.totalAmount;
      final couponDetails = status?.couponDetails;
      final gst = status?.gst;

      return Container(
        margin: const EdgeInsets.only(top: 16),
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
          children: [
            // Coupons Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Remix.ticket_2_line,
                            color: primaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Offers & Discounts',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: couponController.couponTextController,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade900,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter coupon code",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.blueGrey.shade300,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Future.delayed(Duration.zero, () {
                              couponController.applyCoupon();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(
                            "Apply",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF8F9FB)),

            // Bill Details Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bill Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    label: "Subtotal",
                    value: "₹${totalAmount?.total ?? '0'}",
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    label: "Coupon Discount",
                    value: "- ₹${couponDetails?.couponAmount ?? '0'}",
                    valueColor: Colors.green.shade600,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    label: "GST Charges",
                    value: "+ ₹${gst?.gstAmount ?? '0'}",
                  ),
                ],
              ),
            ),

            // Grand Total Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.04),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Grand Total",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  Text(
                    "₹${totalAmount?.grandTotal ?? '0'}",
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.blueGrey.shade700,
          ),
        ),
      ],
    );
  }
}
