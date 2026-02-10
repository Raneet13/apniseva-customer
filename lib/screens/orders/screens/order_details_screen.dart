import 'package:apniseva/screens/orders/order_controller/order_details_controller.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cart/cart_controller/cart_controller.dart';
import '../../../utils/api_strings/api_strings.dart';
import '../../../utils/input_field.dart';

import '../../profile/profile_sections/profile_app_bar.dart';
import '../order_details_model/order_details_model.dart';

class OrderBookingDetails extends StatefulWidget {
  String status;
  OrderBookingDetails({required this.status, Key? key}) : super(key: key);

  @override
  State<OrderBookingDetails> createState() => _OrderBookingDetailsState();
}

class _OrderBookingDetailsState extends State<OrderBookingDetails> {
  final orderDetailsController = Get.put(OrderDetailsController());
  var _razorpay = Razorpay();
  String error = '';
  final CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      orderDetailsController.getOrderDetails();
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void additionalPayment() async {
    var options = {
      'key': orderDetailsController.razorPayKey,
      "amount": int.parse(orderDetailsController
              .orderDetailsModel.value.messages!.status!.otherDtl!.dueAmount
              .toString()) *
          100,
      "currency": "INR",
      'name': orderDetailsController.firstName.toString(),
      'description': orderDetailsController.userId.toString(),
      'prefill': {
        'contact': orderDetailsController.number.toString(),
        'email': orderDetailsController.email.toString()
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderDetailsController.payAmount = orderDetailsController
        .orderDetailsModel.value.messages!.status!.otherDtl!.dueAmount;
    orderDetailsController.paymentId = response.paymentId.toString();
    Future.delayed(Duration.zero, () {
      orderDetailsController.aditionalPayment();
    });
    Fluttertoast.showToast(msg: "Payment Successful");
    refresh();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed: ${response.code}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> refresh() async {
    return Future.delayed(Duration.zero, () {
      orderDetailsController.getOrderDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = orderDetailsController.isLoading.value;
      if (isLoading) {
        return Scaffold(
          backgroundColor: const Color(0xFFFBFBFE),
          appBar: PrimaryAppBar(title: "Booking Details"),
          body: Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: primaryColor,
            ),
          ),
        );
      }

      final statusData =
          orderDetailsController.orderDetailsModel.value.messages?.status;
      if (statusData == null) {
        return Scaffold(
          backgroundColor: const Color(0xFFFBFBFE),
          appBar: PrimaryAppBar(title: "Booking Details"),
          body: Center(
            child: Text(
              "Booking details not found",
              style: GoogleFonts.poppins(color: Colors.blueGrey),
            ),
          ),
        );
      }

      final otherDtl = statusData.otherDtl!;

      return Scaffold(
        backgroundColor: const Color(0xFFFBFBFE),
        appBar: PrimaryAppBar(title: "Booking Details"),
        body: RefreshIndicator(
          onRefresh: refresh,
          color: primaryColor,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              _buildHeader(otherDtl),
              const SizedBox(height: 24),
              _buildServiceDetails(statusData),
              const SizedBox(height: 24),
              if (statusData.additinalOrders != null &&
                  statusData.additinalOrders!.isNotEmpty) ...[
                _buildAdditionalOrders(statusData),
                const SizedBox(height: 24),
              ],
              _buildBillSummary(otherDtl),
              const SizedBox(height: 24),
              AddressDetails(getAddress: statusData.address),
              const SizedBox(height: 24),
              OrderSchedule(getOrderSchedule: otherDtl),
              const SizedBox(height: 24),
              if (otherDtl.status == "5") ...[
                const RateAndReview(),
                const SizedBox(height: 48),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(OtherDtl otherDtl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blueGrey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    otherDtl.orderId ?? "",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Remix.calendar_check_line,
                size: 16,
                color: Colors.blueGrey.shade300,
              ),
              const SizedBox(width: 8),
              Text(
                otherDtl.bookingDate ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.blueGrey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Push OTP badge to the right
              const Spacer(),

              if (otherDtl.verifyOtp != null)
                _buildOtpBadge(otherDtl.verifyOtp!),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOtpBadge(String otp) {
    final isVerified = otp == '1';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isVerified
            ? Colors.green.withOpacity(0.08)
            : primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isVerified
                ? Colors.green.withOpacity(0.1)
                : primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            "OTP",
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isVerified ? Colors.green : primaryColor,
              letterSpacing: 1,
            ),
          ),
          Text(
            isVerified ? "VERIFIED" : otp,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isVerified ? Colors.green : primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails(Status status) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildSectionHeader(Remix.service_line, "Booked Services"),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: status.allOrders!.length,
            separatorBuilder: (context, index) => const Divider(
                height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
            itemBuilder: (context, index) {
              final order = status.allOrders![index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  order.productName ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                subtitle: Text(
                  "Quantity: ${order.qty}",
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.blueGrey.shade400),
                ),
                trailing: Text(
                  "₹${order.price}",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOrders(Status status) {
    const Color orangeOpacity10 = Color(0x1AFF9800);
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.03),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildSectionHeader(Remix.add_circle_line, "Additional Services",
              iconColor: Colors.orange),
          Divider(height: 1, thickness: 1, color: orangeOpacity10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: status.additinalOrders!.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, thickness: 1, color: orangeOpacity10),
            itemBuilder: (context, index) {
              final order = status.additinalOrders![index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  order.productName ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
                trailing: Text(
                  "₹${order.price}",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
              );
            },
          ),
          if (status.otherDtl?.status == "2")
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () => orderDetailsController.aceptAdditionalBill(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  "Accept Additional Bill",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBillSummary(OtherDtl otherDtl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSectionHeader(Remix.bill_line, "Bill Summary"),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSummaryRow("Total Price", "₹${otherDtl.totalPrice}"),
                const SizedBox(height: 12),
                _buildSummaryRow("Discount", "-₹${otherDtl.discount}",
                    isDiscount: true),
                const SizedBox(height: 12),
                _buildSummaryRow("GST", "₹${otherDtl.gst}"),
                const SizedBox(height: 16),
                const Divider(
                    height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
                const SizedBox(height: 16),
                _buildSummaryRow("Grand Total", "₹${otherDtl.grandTotal}",
                    isBold: true),
                const SizedBox(height: 12),
                _buildSummaryRow("Paid Amount", "₹${otherDtl.paidAmount}",
                    color: Colors.green),
                if (otherDtl.dueAmount != null &&
                    double.tryParse(otherDtl.dueAmount.toString()) != null &&
                    double.parse(otherDtl.dueAmount.toString()) > 0) ...[
                  const SizedBox(height: 12),
                  _buildSummaryRow("Due Amount", "₹${otherDtl.dueAmount}",
                      color: Colors.red, isBold: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => additionalPayment(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      "Pay Pending Amount",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isDiscount = false, bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? Colors.blueGrey.shade900 : Colors.blueGrey.shade500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color:
                color ?? (isDiscount ? Colors.green : Colors.blueGrey.shade900),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? primaryColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor ?? primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

class AddressDetails extends StatelessWidget {
  final List<Address>? getAddress;
  const AddressDetails({Key? key, this.getAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (getAddress == null || getAddress!.isEmpty) return const SizedBox();
    final address = getAddress![0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(Remix.map_pin_2_line, "Service Address"),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressRow(Remix.user_3_line, address.firstName ?? ""),
                  const SizedBox(height: 12),
                  _buildAddressRow(Remix.phone_line, address.number ?? ""),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Remix.home_4_line,
                          size: 18, color: Colors.blueGrey.shade300),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "${address.address1}, ${address.adress2}, ${address.state} - ${address.pincode}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.blueGrey.shade600,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey.shade300),
        const SizedBox(width: 12),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class OrderSchedule extends StatefulWidget {
  final OtherDtl? getOrderSchedule;
  const OrderSchedule({Key? key, this.getOrderSchedule}) : super(key: key);

  @override
  State<OrderSchedule> createState() => _OrderScheduleState();
}

class _OrderScheduleState extends State<OrderSchedule> {
  final cartController = Get.put(CartController());
  final orderDetailsController = Get.put(OrderDetailsController());

  Future<void> refresh() async {
    return Future.delayed(Duration.zero, () {
      orderDetailsController.getOrderDetails();
    });
  }

  void orderReschedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Reschedule Booking",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Choose a new date and time for your service",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.blueGrey.shade400,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      PickerInputField(
                        pick: 'Date',
                        hintText: 'Select Date',
                        controller: cartController.redateController,
                        prefixIcon: Remix.calendar_line,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      PickerInputField(
                        pick: 'Time',
                        hintText: 'Select Time',
                        controller: cartController.retimeController,
                        prefixIcon: Remix.timer_2_line,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString(
                    ApiStrings.orderID, widget.getOrderSchedule!.orderId!);
                await cartController.Reshedule();
                Navigator.pop(context);
                refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                "Confirm Schedule",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedule = widget.getOrderSchedule!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Icon(Remix.time_line, color: primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Schedule Info",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey.shade800,
                      ),
                    ),
                  ],
                ),
                if (schedule.verifyOtp != '1')
                  TextButton(
                    onPressed: orderReschedule,
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      "Reschedule",
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildInfoCol(Remix.calendar_event_line, "Date",
                    schedule.bookingDate ?? ""),
                const SizedBox(width: 48),
                _buildInfoCol(
                    Remix.time_line, "Time", schedule.bookingTime ?? ""),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCol(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.blueGrey.shade300),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade400,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey.shade800,
          ),
        ),
      ],
    );
  }
}

class RateAndReview extends StatefulWidget {
  const RateAndReview({super.key});

  @override
  State<RateAndReview> createState() => _RateAndReviewState();
}

class _RateAndReviewState extends State<RateAndReview> {
  final orderDetailsController = Get.put(OrderDetailsController());

  Future<void> refresh() async {
    return Future.delayed(Duration.zero, () {
      orderDetailsController.getOrderDetails();
    });
  }

  void showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          title: Text(
            "Rate Service",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800, color: Colors.blueGrey.shade900),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRatingSection(
                  "Technician Rating",
                  (rating) => orderDetailsController.rateTechnician = rating,
                  orderDetailsController.technicianFeedbackController,
                ),
                const SizedBox(height: 24),
                _buildRatingSection(
                  "ApniSeva Experience",
                  (rating) => orderDetailsController.rateCompany = rating,
                  orderDetailsController.cmpanyFeedbackController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel",
                  style: GoogleFonts.poppins(
                      color: Colors.blueGrey, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                final other = orderDetailsController
                    .orderDetailsModel.value.messages!.status!.otherDtl!;
                preferences.setString(
                    ApiStrings.orderID, other.orderId.toString());
                preferences.setString(
                    ApiStrings.technicianId, other.technicianId.toString());
                await orderDetailsController.rateAndRevew();
                Navigator.pop(context);
                refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Submit",
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(String title, Function(double) onUpdate,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.blueGrey.shade800)),
        const SizedBox(height: 12),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          itemCount: 5,
          itemSize: 32,
          unratedColor: Colors.grey.shade200,
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: onUpdate,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: "Write your feedback...",
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final status =
        orderDetailsController.orderDetailsModel.value.messages!.status!;
    final reviews = status.rattingdetails;

    if (reviews != null && reviews.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            _buildSectionHeader(Remix.star_line, "Your Review"),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const Divider(
                  height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            index == 0
                                ? "Technician Rating"
                                : "ApniSeva Experience",
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey.shade800),
                          ),
                          RatingBarIndicator(
                            rating:
                                double.tryParse(review.rating.toString()) ?? 0,
                            itemBuilder: (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 16,
                          ),
                        ],
                      ),
                      if (review.review != null &&
                          review.review!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          review.review!,
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: Colors.blueGrey.shade500),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return Center(
      child: ElevatedButton.icon(
        onPressed: () => showRatingDialog(context),
        icon: const Icon(Remix.star_fill, size: 18),
        label: const Text("Rate the Service"),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(200, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
