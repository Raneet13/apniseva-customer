import 'package:apniseva/controller/order_details_controller/order_details_controller.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/cart_controller/cart_controller.dart';
import '../../../utils/api_strings/api_strings.dart';
import '../../../utils/input_field.dart';
import '../../cart/cart_sections/cart_order_schedule.dart';
import '../../cart/cart_strings/cart_strings.dart';
import '../../profile/profile_sections/profile_app_bar.dart';
import '../order_details_model/order_details_model.dart';
import '../order_widget/order_strings.dart';

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
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  // Future<void> refresh() async {
  //   return Future.delayed(Duration.zero, () {
  //     cartController.getCartData();
  //   });
  // }

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
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderDetailsController.payAmount = orderDetailsController
        .orderDetailsModel.value.messages!.status!.otherDtl!.dueAmount;
    orderDetailsController.paymentId = response.paymentId.toString();
    // Fluttertoast.showToast(
    //     msg: "SUCCESS:paymentID${response.paymentId.toString()}");
    // Fluttertoast.showToast(msg: "SUCCESS: ");
    Future.delayed(Duration.zero, () {
      orderDetailsController.aditionalPayment();
    });
    Fluttertoast.showToast(msg: "SUCCESS: ");
    refresh();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR: ${response.code}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ");
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    _razorpay.clear();
  }

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero, () {
  //     orderDetailsController.getOrderDetails();
  //   });
  //   super.initState();
  // }

  Future<void> refresh() async {
    return Future.delayed(Duration.zero, () {
      orderDetailsController.getOrderDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);

    return Obx(() {
      return Scaffold(
        appBar: PrimaryAppBar(
          title: OrdersDetailStrings.title,
        ),
        body: orderDetailsController.isLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Theme.of(context).primaryColor,
              ))
            : RefreshIndicator(
                onRefresh: refresh,
                color: Theme.of(context).primaryColor,
                strokeWidth: 2.0,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // OrderID
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: OrdersDetailStrings.orderID,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                TextSpan(
                                  text: orderDetailsController
                                      .orderDetailsModel
                                      .value
                                      .messages!
                                      .status!
                                      .otherDtl!
                                      .orderId,
                                  style: Theme.of(context).textTheme.labelSmall,
                                )
                              ])),
//                               SizedBox(height: height * 0.005),
// //datetime solve
                              Text(
                                // "${DateFormat('yyyy-MMMM-dd').format(orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.bookingDate!)}",
                                // ${DateFormat('hh:mm:ss a').parse(orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.bookingTime!.toString())}
                                orderDetailsController.orderDetailsModel.value
                                    .messages!.status!.otherDtl!.bookingDate!
                                    .toString(),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          orderDetailsController.orderDetailsModel.value
                                      .messages!.status!.otherDtl!.verifyOtp !=
                                  null
                              ? Container(
                                  // height: 50,
                                  width: 80,
                                  padding: const EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    children: [
                                      Text(
                                        'OTP',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      Text(
                                        orderDetailsController
                                                    .orderDetailsModel
                                                    .value
                                                    .messages!
                                                    .status!
                                                    .otherDtl!
                                                    .verifyOtp ==
                                                '1'
                                            ? "Verified"
                                            : orderDetailsController
                                                .orderDetailsModel
                                                .value
                                                .messages!
                                                .status!
                                                .otherDtl!
                                                .verifyOtp!,
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .fontSize,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.045),

                    // HeadLine
                    const ProductHeader(),
                    Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderDetailsController.orderDetailsModel
                                .value.messages!.status!.allOrders!.length,
                            itemBuilder: (BuildContext context, int index) {
                              List<AllOrder>? allOrders = orderDetailsController
                                  .orderDetailsModel
                                  .value
                                  .messages!
                                  .status!
                                  .allOrders!;
                              return Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4.0),
                                    child: Text(
                                      allOrders[index].productName!,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  )),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        allOrders[index].qty!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "₹ ${allOrders[index].price!}",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),

                    Visibility(
                        visible: orderDetailsController.orderDetailsModel.value
                                .messages!.status!.additinalOrders!.isEmpty
                            ? false
                            : true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.maxFinite,
                                color: Colors.grey.shade200,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Additional Products',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .fontSize,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .color),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Product"),
                                  Text("Quantity"),
                                  Text("Price")
                                ],
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: orderDetailsController
                                      .orderDetailsModel
                                      .value
                                      .messages!
                                      .status!
                                      .additinalOrders!
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          child: Text(
                                            orderDetailsController
                                                .orderDetailsModel
                                                .value
                                                .messages!
                                                .status!
                                                .additinalOrders![index]
                                                .productName!,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        )),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "${orderDetailsController.orderDetailsModel.value.messages!.status!.additinalOrders![index].qty!}",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        )),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "₹ ${orderDetailsController.orderDetailsModel.value.messages!.status!.additinalOrders![index].price!}",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        )),
                                      ],
                                    );
                                  }),
                              orderDetailsController.orderDetailsModel.value
                                          .messages!.status!.otherDtl!.status !=
                                      "2"
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: TextButton(
                                              onPressed: () =>
                                                  orderDetailsController
                                                      .aceptAdditionalBill(),
                                              //additionalPayment(), //orderDetailsController
                                              //.aditionalPayment(), //additionalPayment(),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          primaryColor
                                                              .withOpacity(
                                                                  0.8)),
                                                  padding:
                                                      MaterialStatePropertyAll(
                                                          EdgeInsets.all(5)),
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10)))),
                                              child: Text(
                                                "Acept All Additinal Bill",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontSize: 16,
                                                ),
                                              ))),
                                    ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                            ],
                          ),
                        )),
                    const Divider(
                      thickness: 1.0,
                    ),

                    // Transaction Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              OrdersDetailStrings.totalPrice,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              OrdersDetailStrings.discount,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              OrdersDetailStrings.gst,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(height: height * 0.01),
                            FittedBox(
                              child: Text(
                                OrdersDetailStrings.grandTotal,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            FittedBox(
                              child: Text(
                                OrdersDetailStrings.dueAmount,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            FittedBox(
                              child: Text(
                                OrdersDetailStrings.paidAmount,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            )
                          ],
                        )),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '₹ ${orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.totalPrice.toString()}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              '₹ ${orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.discount.toString()}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              '₹ ${orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.gst}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              '₹ ${orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.grandTotal.toString()}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              '₹ ${orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.dueAmount.toString()}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              '₹ ${orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.paidAmount.toString()}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        )),
                      ],
                    ),
                    orderDetailsController.orderDetailsModel.value.messages!
                                    .status!.otherDtl!.dueAmount ==
                                0 ||
                            orderDetailsController.orderDetailsModel.value
                                    .messages!.status!.otherDtl!.dueAmount ==
                                null
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                    onPressed: () => additionalPayment(),
                                    //additionalPayment(), //orderDetailsController
                                    //.aditionalPayment(), //additionalPayment(),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                primaryColor.withOpacity(0.8)),
                                        padding: MaterialStatePropertyAll(
                                            EdgeInsets.all(5)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10)))),
                                    child: Text(
                                      "PAY ₹${orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.dueAmount.toString()}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.none,
                                        fontSize: 16,
                                      ),
                                    ))),
                          ),
                    SizedBox(
                      height: height * 0.04,
                    ),

                    AddressDetails(
                        getAddress: orderDetailsController.orderDetailsModel
                            .value.messages!.status!.address!),

                    OrderSchedule(
                        getOrderSchedule: orderDetailsController
                            .orderDetailsModel
                            .value
                            .messages!
                            .status!
                            .otherDtl!),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    orderDetailsController.orderDetailsModel.value.messages!
                                .status!.otherDtl!.status ==
                            "5"
                        ? RateAndReview()
                        : SizedBox(),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}

class ProductHeader extends StatelessWidget {
  const ProductHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Service
          Expanded(
            child: Text(
              OrdersDetailStrings.service,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          //Quantity
          Expanded(
            child: Text(
              OrdersDetailStrings.quantity,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          // Price
          Expanded(
            child: Text(
              OrdersDetailStrings.price,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class AddressDetails extends StatelessWidget {
  final List<Address>? getAddress;
  const AddressDetails({
    Key? key,
    this.getAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              // color: Colors.grey.shade50,
              child: Text(
                'Address Details',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineMedium!.fontSize,
                    color: Theme.of(context).textTheme.titleLarge!.color),
              ),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getAddress![0].firstName!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    getAddress![0].number!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    getAddress![0].email!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    getAddress![0].address1!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    getAddress![0].adress2!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    getAddress![0].state!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    getAddress![0].pincode!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  orderReschedule() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (builder) {
          return Card(
            elevation: 1.5,
            color: Colors.grey.shade100,
            child: Container(
              width: width,
              height: height * 0.3,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      CartStrings.schedule,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                CartStrings.date,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            PickerInputField(
                              pick: 'Date',
                              hintText: 'Date',
                              controller: cartController.redateController,
                              prefixIcon: Remix.calendar_line,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                CartStrings.time,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            PickerInputField(
                              pick: 'Time',
                              hintText: 'Time',
                              controller: cartController.retimeController,
                              prefixIcon: Remix.timer_2_line,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                    child: SizedBox(
                      height: height * 0.05,
                      width: width * 0.7,
                      child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString(
                                ApiStrings.orderID,
                                orderDetailsController.orderDetailsModel.value
                                    .messages!.status!.otherDtl!.orderId!);
                            // debugPrint(orderDetailsController.orderDetailsModel
                            //     .value.messages!.status!.otherDtl!.orderId);
                            await cartController.Reshedule();
                            Navigator.pop(context);
                            // Get.back();
                            refresh();
                          },
                          child: Text(
                            "Schedule",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              // color: Colors.grey.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Schedule At',
                    style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .fontSize,
                        color: Theme.of(context).textTheme.titleLarge!.color),
                  ),
                  orderDetailsController.orderDetailsModel.value.messages!
                              .status!.otherDtl!.verifyOtp ==
                          '1'
                      ? SizedBox()
                      : TextButton(
                          onPressed: () => orderReschedule(),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(primaryColor),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(5)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          child: Text(
                            "Reschedule",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 16,
                            ),
                          ))
                ],
              ),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schedule Date: ${widget.getOrderSchedule!.bookingDate}",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    "Schedule Time: ${widget.getOrderSchedule!.bookingTime}",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            // TextButton.icon(onPressed: (){}, icon: ListView(
            //   children: [Icon(Icons.star)],
            // ), label: Text("Give Rate"))
          ],
        ),
      ),
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

  rateAndREview(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            // backgroundColor: Colors.white,
            title: Text("Rate technician & ApniSeva Service"),

            titleTextStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                fontWeight: FontWeight.bold,
                color: primaryColor),
            content: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 0, bottom: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8.0),
                          // color: Colors.grey.shade50,
                          child: Text(
                            'Rate Technician',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .color),
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Rate",
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 30,
                                    glow: true,
                                    glowColor: Colors.white,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      orderDetailsController.rateTechnician =
                                          rating;
                                      print(rating);
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                maxLines: 3,
                                controller: orderDetailsController
                                    .technicianFeedbackController,
                                style: TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 15,
                                        bottom: 5),
                                    // label: Text("Give your Opnion"),
                                    // labelText: "",
                                    // border: OutlineInputBorder(),
                                    // floatingLabelAlignment:
                                    //     FloatingLabelAlignment.start,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "Write Feedback...."),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8.0),
                          // color: Colors.grey.shade50,
                          child: Text(
                            'Rate ApniSeva Service',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .color),
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Rate",
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  RatingBar.builder(
                                    initialRating:
                                        orderDetailsController.rateCompany,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 30,
                                    glow: true,
                                    glowColor: Colors.white,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      orderDetailsController.rateCompany =
                                          rating;
                                      // print(rating);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                maxLines: 3,
                                controller: orderDetailsController
                                    .cmpanyFeedbackController,
                                style: TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 15,
                                        bottom: 5),
                                    // label: Text("Give your Opnion"),
                                    // labelText: "",
                                    // border: OutlineInputBorder(),
                                    // floatingLabelAlignment:
                                    //     FloatingLabelAlignment.start,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "Write Feedback...."),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    //orderDetailsController.orderDetailsModel.value.messages!.status!.otherDtl!.grandTotal.toString()
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setString(
                        ApiStrings.orderID,
                        orderDetailsController.orderDetailsModel.value.messages!
                            .status!.otherDtl!.orderId
                            .toString());
                    preferences.setString(
                        ApiStrings.technicianId,
                        orderDetailsController.orderDetailsModel.value.messages!
                            .status!.otherDtl!.technicianId
                            .toString());
                    //      preferences.setString(
                    // ApiStrings.orderID,
                    // orderDetailsController.orderDetailsModel.value.messages!
                    //     .status!.otherDtl!.orderId
                    //     .toString());
                    orderDetailsController.rateAndRevew();
                    //   Get.back();
                    //  refresh();
                    Navigator.pop(context);
                    // Get.back();
                    refresh();
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
              // remindButton,
              // cancelButton,
              // launchButton,
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return orderDetailsController.orderDetailsModel.value.messages!.status!
                .rattingdetails!.isNotEmpty &&
            orderDetailsController
                    .orderDetailsModel.value.messages!.status!.rattingdetails !=
                null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 8.0),
                    // color: Colors.grey.shade50,
                    child: Text(
                      'Your Rating & Review',
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontSize,
                          color: Theme.of(context).textTheme.titleLarge!.color),
                    ),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(
                            left: 8.0, right: 0.0, top: 10, bottom: 10),
                        // leading: Icon(
                        //   Icons.account_circle,
                        //   size: 50,
                        // ),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: 0),
                        title: Text("Technician Ratting"),
                        isThreeLine: true,
                        subtitle: Transform.translate(
                          offset: Offset(0, 0),
                          child: RatingBarIndicator(
                            rating: double.parse(orderDetailsController
                                    .orderDetailsModel
                                    .value
                                    .messages!
                                    .status!
                                    .rattingdetails![0]
                                    .rating
                                    .toString() ??
                                ""),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "${orderDetailsController.orderDetailsModel.value.messages!.status!.rattingdetails![0].review.toString()}",
                            style: Theme.of(context).textTheme.labelMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, top: 0, bottom: 0),
                        child: Divider(),
                      ),
                      ListTile(
                        minVerticalPadding: 0,
                        contentPadding: EdgeInsets.only(
                            left: 8.0, right: 0.0, top: 10, bottom: 10),
                        // leading: Icon(
                        //   Icons.account_circle,
                        //   size: 50,
                        // ),
                        // visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                        title: Text("Exprience With Apni Seva"),
                        // isThreeLine: true,
                        subtitle: Transform.translate(
                          offset: Offset(0, 0),
                          child: RatingBarIndicator(
                            rating: double.parse(orderDetailsController
                                    .orderDetailsModel
                                    .value
                                    .messages!
                                    .status!
                                    .rattingdetails![1]
                                    .rating
                                    .toString() ??
                                ""),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 0, bottom: 0, right: 8),
                        child: Text(
                          "${orderDetailsController.orderDetailsModel.value.messages!.status!.rattingdetails![1].review.toString()}",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: TextButton.icon(
              onPressed: () => rateAndREview(context),
              icon: Icon(
                Icons.star,
                color: Colors.amber,
              ),
              label: Text("Rate the service",
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize:
                          Theme.of(context).textTheme.bodyLarge!.fontSize)),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(primaryColor),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
            ),
          );
  }
  // return }
}
