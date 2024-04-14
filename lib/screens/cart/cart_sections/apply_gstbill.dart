import 'package:apniseva/screens/cart/cart_strings/cart_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cart_controller/cart_controller.dart';

class ApplyGstbill extends StatefulWidget {
  const ApplyGstbill({
    Key? key,
  }) : super(key: key);

  @override
  State<ApplyGstbill> createState() => _ApplyGstbillState();
}

class _ApplyGstbillState extends State<ApplyGstbill> {
  final couponController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);

    // return Obx(() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ExpansionTile(
        dense: true,
        backgroundColor: Colors.grey.shade200,
        collapsedBackgroundColor: Colors.grey.shade200,
        title: Text(
          "Do You Want GST Bill",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Column(
              children: [
                Card(
                  elevation: 1.5,
                  color: Colors.grey.shade100,
                  child: Container(
                    width: width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            CartStrings.gstno,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        TextFormField(
                          controller: couponController.gstTextController,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight
                                  .bold), //Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () async {
                            Future.delayed(Duration.zero, () {
                              couponController.applyGst();
                            });
                          },
                          child: Text(CartStrings.applygst),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       CartStrings.subTotal,
                        //       style: Theme.of(context).textTheme.titleLarge,
                        //     ),
                        //     Text(
                        //       '₹ ${couponController.couponDataModel.value.messages!.status!.totalAmount!.total}',
                        //       style: Theme.of(context).textTheme.labelMedium,
                        //     )
                        //   ],
                        // ),
                        // const Divider(
                        //   thickness: 1.0,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       CartStrings.couponApplied,
                        //       style: Theme.of(context).textTheme.titleLarge,
                        //     ),
                        //     Text(
                        //       '₹ ${couponController.couponDataModel.value.messages!.status!.couponDetails!.couponAmount}',
                        //       style: Theme.of(context).textTheme.labelMedium,
                        //     )
                        //   ],
                        // ),
                        // const Divider(
                        //   thickness: 1.0,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       CartStrings.gst,
                        //       style: Theme.of(context).textTheme.titleLarge,
                        //     ),
                        //     Text(
                        //       "₹ ${couponController.couponDataModel.value.messages!.status!.gst!.gstAmount!}",
                        //       style: Theme.of(context).textTheme.labelMedium,
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                // Card(
                //   elevation: 1.5,
                //   color: Colors.grey.shade100,
                //   child: Container(
                //     width: width,
                //     height: 47,
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           CartStrings.total,
                //           style: Theme.of(context).textTheme.labelLarge,
                //         ),
                //         Text(
                //           "₹ ${couponController.couponDataModel.value.messages!.status!.totalAmount!.grandTotal}",
                //           style: Theme.of(context).textTheme.headlineMedium,
                //         )
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(height: height * 0.01),
              ],
            ),
          ),
          // Card(
          //   elevation: 1.5,
          //   color: Colors.grey.shade100,
          //   child: Container(
          //     width: width,
          //     height: 47,
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           CartStrings.total,
          //           style: Theme.of(context).textTheme.labelLarge,
          //         ),
          //         Text(
          //           "₹ ${couponController.couponDataModel.value.messages!.status!.totalAmount!.grandTotal}",
          //           style: Theme.of(context).textTheme.headlineMedium,
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
    // });
  }
}
