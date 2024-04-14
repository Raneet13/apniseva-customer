import 'package:apniseva/controller/order_controller/order_controller.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/order_model/order_model.dart';
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);

    return Obx(() {
      return Scaffold(
          appBar: OrdersAppBar(title: OrderStrings.title),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: Container(
              width: width,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: orderController.fetchOrder.value == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 2.5,
                      ),
                    )
                  : orderController.orderDataModel.value.messages!.status!
                          .orderdtls!.isEmpty
                      ? Center(
                          child: InkWell(
                            onTap: () {
                              debugPrint(orderController.orderDataModel.value
                                  .messages!.status!.orderdtls!.length
                                  .toString());
                            },
                            child: const Text(
                              'No order history\nPlease! Make your first order.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Card(
                                elevation: 1.2,
                                color: Colors.grey.shade200,
                                child: Container(
                                  // height: height * 0.24,
                                  width: width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // OrderID
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 5.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0)),
                                                child: Text(
                                                  orderData![index].status!,
                                                  style: TextStyle(
                                                      fontSize:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .titleSmall!
                                                              .fontSize,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .color),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              RichText(
                                                  text: TextSpan(children: [
                                                TextSpan(
                                                  text: OrderStrings.orderID,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                TextSpan(
                                                  text:
                                                      orderData[index].orderId!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall,
                                                ),
                                              ])),
                                            ],
                                          ),
                                          if (orderData[index].status! ==
                                              "Additional Bill Added")
                                            Column(
                                              children: [
                                                AcceptOrderButton(
                                                  onPressed: () async {
                                                    orderController.statusId =
                                                        3;
                                                    orderController
                                                        .acceptRejectOrder(
                                                            orderData[index]
                                                                .orderId!);

                                                    debugPrint("Accept");
                                                  },
                                                ),
                                                const SizedBox(height: 5),
                                                RejectOrderButton(
                                                  onPressed: () {
                                                    orderController.statusId =
                                                        7;
                                                    orderController
                                                        .acceptRejectOrder(
                                                            orderData[index]
                                                                .orderId!);

                                                    debugPrint("Reject");
                                                  },
                                                ),
                                              ],
                                            )
                                          else if (orderData[index].status! ==
                                              "Work Completed")
                                            IconButton(
                                                onPressed: () {
                                                  orderController.generatePDF(
                                                      orderData[index].orderId);
                                                },
                                                icon: const Icon(Icons
                                                    .sim_card_download_rounded))
                                          else
                                            Container()
                                        ],
                                      ),
                                      // const Spacer(),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // Service Date & Time
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                          text: OrderStrings.scheduleDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        TextSpan(
                                          text: orderData[index].sheduleDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        )
                                      ])),
                                      // SizedBox(height: height * 0.005),
                                      const SizedBox(
                                        height: 5,
                                      ),

                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                          text: OrderStrings.scheduleTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        TextSpan(
                                          text: orderData[index].sheduledTime!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        )
                                      ])),
                                      // SizedBox(height: height * 0.005),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // Order Date
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  "${OrderStrings.orderDate}:  ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            TextSpan(
                                              text: orderData[index]
                                                  .orderDateTime,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            )
                                          ])),
                                          InkWell(
                                            onTap: () async {
                                              SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              pref.setString(
                                                  ApiStrings.orderID,
                                                  orderData[index]
                                                      .orderId
                                                      .toString());
                                              debugPrint(orderData[index]
                                                  .orderId
                                                  .toString());
                                              Get.to(() => OrderBookingDetails(
                                                    status: orderData![index]
                                                        .status!,
                                                  ));
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  OrderStrings.viewDetails,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.double_arrow_rounded,
                                                  size: 14,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height * 0.005),
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
}
