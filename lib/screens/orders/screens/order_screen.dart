import 'package:apniseva/screens/orders/order_controller/order_controller.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/order_model/order_model.dart';
import '../../../utils/color.dart';

import '../sections/booking_appbar.dart';
import 'order_details_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final orderController = Get.put(OrderController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      orderController.getOrders();
    });
    super.initState();
  }

  Future<void> refresh() async {
    return Future.delayed(Duration.zero, () {
      orderController.getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: const Color(0xFFFBFBFE),
        appBar: OrdersAppBar(title: "My Bookings"),
        body: RefreshIndicator(
          onRefresh: refresh,
          color: primaryColor,
          child: orderController.fetchOrder.value == true
              ? _buildLoadingState()
              : orderController
                      .orderDataModel.value.messages!.status!.orderdtls!.isEmpty
                  ? _buildEmptyState()
                  : _buildOrderList(),
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: primaryColor,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            "Fetching your bookings...",
            style: GoogleFonts.poppins(
              color: Colors.blueGrey.shade400,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Remix.calendar_todo_line,
                  size: 80,
                  color: primaryColor.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "No Bookings Found",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "You haven't scheduled any services yet. Start exploring and book your first service today!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.blueGrey.shade500,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  "Explore Services",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    final orderdtls =
        orderController.orderDataModel.value.messages!.status!.orderdtls!;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: orderdtls.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orderdtls[index]);
      },
    );
  }

  Widget _buildOrderCard(Orderdtl order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _navigateToDetails(order),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(order.status!),
                      if (order.status == "Work Completed")
                        IconButton(
                          onPressed: () =>
                              orderController.generatePDF(order.orderId),
                          icon: Icon(Remix.download_2_line,
                              color: primaryColor, size: 20),
                          visualDensity: VisualDensity.compact,
                        )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Order ID: ${order.orderId}",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Remix.calendar_event_line, "Scheduled Date",
                      order.sheduleDate!),
                  const SizedBox(height: 8),
                  _buildInfoRow(Remix.time_line, "Time", order.sheduledTime!),
                  const SizedBox(height: 16),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF8F9FB)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ordered on: ${order.orderDateTime}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.blueGrey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "View Details",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Remix.arrow_right_s_line,
                              size: 18, color: primaryColor),
                        ],
                      ),
                    ],
                  ),
                  _buildActionButtons(order),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case "Work Completed":
        color = Colors.green;
        break;
      case "Pending":
      case "Accept":
        color = Colors.orange;
        break;
      case "Reject":
      case "Cancelled":
        color = Colors.red;
        break;
      default:
        color = primaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey.shade300),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.blueGrey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.blueGrey.shade800,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Orderdtl order) {
    if (order.status != "Additional Bill Added") return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                orderController.statusId = 3;
                orderController.acceptRejectOrder(order.orderId!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("Accept Bill",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                orderController.statusId = 7;
                orderController.acceptRejectOrder(order.orderId!);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red.shade200),
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("Reject",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToDetails(Orderdtl order) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(ApiStrings.orderID, order.orderId.toString());
    Get.to(() => OrderBookingDetails(status: order.status!));
  }
}
