import 'package:apniseva/controller/cart_controller/cart_controller.dart';
import 'package:apniseva/model/cart_model/cart_detail_model/cart_details_model.dart';
import 'package:apniseva/screens/cart/cart_sections/cart_order_schedule.dart';
import 'package:apniseva/screens/cart/cart_strings/cart_strings.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/buttons.dart';
import '../cart_sections/apply_coupon.dart';
import '../cart_sections/apply_gstbill.dart';
import '../cart_sections/cart_appbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _razorpay = Razorpay();
  String error = '';
  final CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      cartController.getCartData();
      cartController.applyCoupon();
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  Future<void> refresh() async {
    return Future.delayed(Duration.zero, () {
      cartController.getCartData();
    });
  }

  void openCheckout() async {
    var options = {
      'key': cartController.razorPayKey,
      "amount": int.parse(cartController.cartTtalAmount.toString()) * 100,
      "currency": "INR",
      'name': cartController.firstName,
      'description': cartController.userId.toString(),
      'prefill': {
        'contact': cartController.number,
        'email': cartController.email
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    cartController.paid_amount = int.parse(cartController.price![0]);
    cartController.payment_id = response.paymentId.toString();
    Fluttertoast.showToast(msg: "SUCESS");
    // Fluttertoast.showToast(
    //     msg:
    //         "SUCCESS: price:${cartController.price![0]}, paymentID${response.paymentId.toString()}");
    // Fluttertoast.showToast(msg: "SUCCESS: ");
    Future.delayed(Duration.zero, () {
      cartController.checkOut();
      refresh();
    });
    Fluttertoast.showToast(msg: "SUCCESS: ");
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);

    return Obx(() {
      return cartController
              .cartDetailsDataModel.value.messages!.status!.allCart!.isEmpty
          ? Scaffold(
              appBar: CartAppBar(
                title: CartStrings.title,
              ),
              body: const Center(child: Text('Cart is Empty')))
          : Scaffold(
              appBar: CartAppBar(
                title: CartStrings.title,
              ),
              body: cartController.fetch.value == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 1.5,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: refresh,
                      child: SingleChildScrollView(
                          child:
                              // cartController.cartDetailsDataModel.value.status == 200 ?
                              Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: List.generate(
                                    cartController
                                        .cartDetailsDataModel
                                        .value
                                        .messages!
                                        .status!
                                        .allCart!
                                        .length, (index) {
                                  List<AllCart>? cartData = cartController
                                      .cartDetailsDataModel
                                      .value
                                      .messages!
                                      .status!
                                      .allCart!;
                                  return Card(
                                      color: Colors.grey.shade200,
                                      child: Container(
                                        height: 75,
                                        alignment: Alignment.center,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 8),
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              width: 60,
                                              height: 75,
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              child: Image.network(
                                                "${ApiEndPoint.imageAPI}/${cartData[index].image}",
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                      height: 110,
                                                      width: 110,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          color: Colors
                                                              .grey.shade100),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'No Image',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall,
                                                      ));
                                                },
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            cartData[index].servicename!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          subtitle: Text(
                                            '₹ ${cartData[index].price}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child:
                                                    Text(cartData[index].qty!),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  SharedPreferences
                                                      preferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  preferences.setString(
                                                      ApiStrings.cartID,
                                                      cartData[index].cartId!);
                                                  Future.delayed(Duration.zero,
                                                      () {
                                                    cartController.removeItem();
                                                  });
                                                  cartData.removeAt(index);
                                                  refresh();
                                                },
                                                child: const Icon(
                                                  Remix.delete_bin_6_fill,
                                                  color: Color(0xFFDC4D42),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                }),
                              ),
                              const ApplyGstbill(),
                              const CartApplyCoupon(),
                              const CartOrderScheduleTotal(),
                              RadioListTile<String>(
                                  title: Text(
                                    CartStrings.pod,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  value: 'cash',
                                  groupValue: cartController.paymentMode,
                                  onChanged: (value) async {
                                    setState(() {
                                      cartController.paymentMode = value;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text(
                                    CartStrings.payOnline,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  value: 'online',
                                  groupValue: cartController.paymentMode,
                                  onChanged: (value) {
                                    setState(() {
                                      cartController.paymentMode = value;
                                    });
                                  }),
                              // RadioListTile(
                              //     title: Text(
                              //       CartStrings.accept,
                              //       style:
                              //           Theme.of(context).textTheme.titleLarge,
                              //     ),
                              //     toggleable: true,
                              //     value: 1,
                              //     groupValue: 1,
                              //     onChanged: (value) {}),
                            ]),
                      )
                          /*: Container(
                  height: height,
                  width: width,
                  alignment: Alignment.center,
                  child: const Text('Your cart is Empty'))*/
                          ),
                    ),
              bottomNavigationBar: BottomAppBar(
                  child: Container(
                width: width,
                height: 65,
                color: Colors.white,
                alignment: Alignment.center,
                child: cartController.cartDetailsDataModel.value.status == 200
                    ? PrimaryButton(
                        width: width * 0.95,
                        height: 47,
                        onPressed: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          String? address =
                              preferences.getString(ApiStrings.addressID);
                          if (address == null) {
                            Get.snackbar('Address', 'Please Select address',
                                colorText: Colors.white);
                          } else if (cartController
                              .dateController.text.isEmpty) {
                            Get.snackbar('Date', 'Select Date',
                                colorText: Colors.white);
                          } else if (cartController
                              .timeController.text.isEmpty) {
                            Get.snackbar('Date', 'Select Time',
                                colorText: Colors.white);
                          } else if (cartController.paymentMode == null) {
                            Get.snackbar('Cart', 'Select Payment method',
                                colorText: Colors.white);
                          } else {
                            if (cartController.paymentMode == 'cash') {
                              Future.delayed(Duration.zero, () {
                                cartController.checkOut();
                                refresh();
                              });
                            } else {
                              openCheckout();
                            }
                          }
                        },
                        child: Text(
                          CartStrings.confirmBooking,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    : PrimaryButton(
                        width: width * 0.95,
                        height: 47,
                        onPressed: () {
                          Get.to(const BottomNavBar());
                        },
                        child: const Text(
                          'Book Service',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
              )));
    });
  }
}
