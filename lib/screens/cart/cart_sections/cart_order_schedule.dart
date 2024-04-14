import 'package:apniseva/controller/cart_controller/cart_controller.dart';
import 'package:apniseva/utils/color.dart';
import 'package:apniseva/utils/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../../address/screen/address_screen.dart';
import '../../address/widget/address_strings.dart';
import '../cart_strings/cart_strings.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.bottom +
            MediaQuery.of(context).padding.top);

    return Column(
      children: [
        Card(
          elevation: 1.5,
          color: Colors.grey.shade100,
          child: Container(
            width: width,
            // height: 47,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => const AddressScreen(isSelectingFromCart: true))
                        ?.then((value) {
                      cartController.getCartData();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Address',
                          style: Theme.of(context).textTheme.labelLarge),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const AddressScreen(
                              isSelectingFromCart: true))?.then((value) {
                            cartController.getCartData();
                          });
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(primaryColor),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape:
                                MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: cartController.addressID == null ? false : true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: AddressStrings.name,
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text:
                                    "${cartController.firstName} ${cartController.lastName}",
                                style: Theme.of(context).textTheme.titleLarge)
                          ])),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: AddressStrings.mobile,
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: cartController.number,
                                style: Theme.of(context).textTheme.titleLarge)
                          ])),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: AddressStrings.email,
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: cartController.email,
                                style: Theme.of(context).textTheme.titleLarge)
                          ])),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: AddressStrings.address1,
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: cartController.address1,
                                style: Theme.of(context).textTheme.titleLarge)
                          ])),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: AddressStrings.address2,
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: cartController.address2,
                                style: Theme.of(context).textTheme.titleLarge)
                          ])),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: AddressStrings.city,
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: cartController.cityName,
                                style: Theme.of(context).textTheme.titleLarge)
                          ])),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: AddressStrings.state,
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: cartController.state,
                                style: Theme.of(context).textTheme.titleLarge)
                          ])),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: AddressStrings.pinCode,
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: cartController.pinCode,
                                style: Theme.of(context).textTheme.titleLarge)
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 1.5,
          color: Colors.grey.shade100,
          child: Container(
            width: width,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            controller: cartController.dateController,
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
                            controller: cartController.timeController,
                            prefixIcon: Remix.timer_2_line,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: height * 0.01),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
