import 'package:apniseva/controller/order_controller/order_controller.dart';
import 'package:apniseva/screens/auth/screens/registration_screen.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/order_model/order_model.dart';
import '../../../utils/buttons.dart';
import '../../../utils/color.dart';
import '../order_widget/order_button/order_button.dart';
import '../order_widget/order_strings.dart';
import '../sections/booking_appbar.dart';
import 'order_details_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final orderController = Get.put(OrderController());
  bool isGuest = false;

  @override
  void initState() {
    checkGuestStatus();
    super.initState();
  }

  checkGuestStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isGuest = pref.getBool('isGuest') ?? false;
    });
    if (!isGuest) {
      orderController.getOrders();
    }
  }

  Future<void> refresh() async {
    if (!isGuest) {
      return orderController.getOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);

    return Obx(() {
      return Scaffold(
          appBar: OrdersAppBar(title: OrderStrings.title),
          body: RefreshIndicator(
            onRefresh: refresh,
            color: primaryColor,
            child: Container(
              width: width,
              height: height,
              child: isGuest
                  ? _buildGuestUI()
                  : orderController.fetchOrder.value == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 2.5,
                          ),
                        )
                      : (orderController.orderDataModel.value.messages?.status?.orderdtls?.isEmpty ?? true)
                          ? Center(
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  'No order history\nPlease! Make your first order.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(color: Colors.blueGrey),
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              itemCount: orderController.orderDataModel.value
                                  .messages!.status!.orderdtls!.length,
                              itemBuilder: (context, index) {
                                List<Orderdtl>? orderData = orderController
                                    .orderDataModel
                                    .value
                                    .messages!
                                    .status!
                                    .orderdtls;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Card(
                                    elevation: 2,
                                    shadowColor: Colors.black.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                                decoration: BoxDecoration(
                                                  color: primaryColor.withOpacity(0.08),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child: Text(
                                                  orderData![index].status ?? "",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ),
                                              if (orderData[index].status == "Work Completed")
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () => orderController.generatePDF(orderData[index].orderId),
                                                  icon: Icon(Icons.download_for_offline_rounded, color: primaryColor, size: 24),
                                                )
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          _buildInfoRow(OrderStrings.orderID, orderData[index].orderId ?? ""),
                                          const SizedBox(height: 6),
                                          _buildInfoRow(OrderStrings.scheduleDate, orderData[index].sheduleDate ?? ""),
                                          const SizedBox(height: 6),
                                          _buildInfoRow(OrderStrings.scheduleTime, orderData[index].sheduledTime ?? ""),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildInfoRow("${OrderStrings.orderDate}: ", orderData[index].orderDateTime ?? ""),
                                              InkWell(
                                                onTap: () async {
                                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                                  pref.setString(ApiStrings.orderID, orderData[index].orderId.toString());
                                                  Get.to(() => OrderBookingDetails(status: orderData[index].status ?? ""));
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      OrderStrings.viewDetails,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(Icons.double_arrow_rounded, size: 14, color: primaryColor)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          if (orderData[index].status == "Additional Bill Added")
                                            Padding(
                                              padding: const EdgeInsets.only(top: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  RejectOrderButton(
                                                    onPressed: () {
                                                      orderController.statusId = 7;
                                                      orderController.acceptRejectOrder(orderData[index].orderId!);
                                                    },
                                                  ),
                                                  const SizedBox(width: 8),
                                                  AcceptOrderButton(
                                                    onPressed: () {
                                                      orderController.statusId = 3;
                                                      orderController.acceptRejectOrder(orderData[index].orderId!);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
            ),
          ));
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: label.endsWith(": ") ? label : "$label: ",
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade400,
          ),
        ),
        TextSpan(
          text: value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade900,
          ),
        ),
      ]),
    );
  }

  Widget _buildGuestUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_bag_outlined,
                  size: 80, color: primaryColor.withOpacity(0.3)),
            ),
            const SizedBox(height: 24),
            Text(
              'Your orders are waiting',
              style: GoogleFonts.poppins(
                color: Colors.blueGrey.shade900,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please login to view your orders\nand track your bookings.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.blueGrey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              width: 220,
              height: 54,
              onPressed: () => Get.offAll(() => const RegistrationScreen()),
              child: const Text(
                'Login / Register',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
