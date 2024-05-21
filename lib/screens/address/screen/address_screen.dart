import 'package:apniseva/controller/cart_controller/cart_controller.dart';
import 'package:apniseva/model/cart_model/cart_detail_model/cart_details_model.dart';
import 'package:apniseva/screens/address/widget/address_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/color.dart';
import 'address_form_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key, this.isSelectingFromCart = false})
      : super(key: key);
  final bool isSelectingFromCart;
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final addressController = Get.put(CartController());
  int _selectedRadioButton = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      addressController.getCartData();
    });
    _selectedRadioButton =
        int.tryParse(addressController.addressID ?? '-1') ?? -1;
    super.initState();
  }

  Future<void> refresh() async {
    return Future.delayed(Duration.zero, () {
      addressController.getCartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.bottom + MediaQuery.of(context).padding.top);

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Remix.arrow_drop_left_line,
              size: Theme.of(context).iconTheme.size,
              color: Colors.white,
            ),
          ),
          title: Text(
            AddressStrings.title,
          ),
          actions: [
            widget.isSelectingFromCart
                ? TextButton(
                    onPressed: () {
                      if (addressController.addressID != null) {
                        Navigator.pop(context);
                      } else {
                        Get.snackbar('error', "Select An Address",
                            colorText: Colors.white);
                        // Get.showSnackbar(
                        //   const GetSnackBar(
                        //     title: 'Error',
                        //     message: "Select an address",
                        //   ),
                        // );
                      }
                    },
                    child: Text(
                      "Submit",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  )
                : const SizedBox()
          ],
        ),
        body: SafeArea(
            child: addressController.fetch.value == true
                ? Center(
                    child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 2.5,
                  ))
                : addressController.cartDetailsDataModel.value.messages!.status!
                            .addressData ==
                        null
                    ? const Center(
                        child: Text('Add Address'),
                      )
                    : RefreshIndicator(
                        onRefresh: refresh,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5.0),
                            child: Column(
                              children: List.generate(
                                  addressController
                                      .cartDetailsDataModel
                                      .value
                                      .messages!
                                      .status!
                                      .addressData!
                                      .length, (index) {
                                AddressDatum addressData = addressController
                                    .cartDetailsDataModel
                                    .value
                                    .messages!
                                    .status!
                                    .addressData![index];
                                return Card(
                                  color: Colors.grey.shade200,
                                  child: Container(
                                      width: width,
                                      padding: const EdgeInsets.only(
                                          left: 15, bottom: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                        text:
                                                            AddressStrings.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium),
                                                    TextSpan(
                                                        text:
                                                            "${addressData.firstName} ${addressData.lastName}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge)
                                                  ])),
                                              const Spacer(),
                                              SizedBox(
                                                height: 30,
                                                width: 50,
                                                child: TextButton(
                                                  child: const Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    SharedPreferences
                                                        preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    preferences.setString(
                                                        ApiStrings.addressID,
                                                        addressData.addressId!);
                                                    debugPrint(
                                                        "Address ID: ${addressData.addressId.toString()}");
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddressFormScreen(
                                                                  apiCall: 1,
                                                                  addressData:
                                                                      addressData,
                                                                )));
                                                    // Get.to(
                                                    //     () => );
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              primaryColor),
                                                      padding:
                                                          MaterialStatePropertyAll(
                                                              EdgeInsets.zero),
                                                      shape: MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ))),
                                                ),
                                              ),
                                              Radio(
                                                  value: int.tryParse(
                                                      addressData.addressId ??
                                                          '0'),
                                                  toggleable: true,
                                                  groupValue:
                                                      _selectedRadioButton,
                                                  onChanged: (value) async {
                                                    SharedPreferences
                                                        preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    preferences.setString(
                                                        ApiStrings.addressID,
                                                        addressData.addressId!);
                                                    String? addressID =
                                                        preferences.getString(
                                                            ApiStrings
                                                                .addressID);
                                                    addressController
                                                        .addressID = addressID;
                                                    setState(() {
                                                      _selectedRadioButton =
                                                          value!;
                                                      addressController
                                                              .firstName =
                                                          addressData.firstName;
                                                      addressController
                                                              .lastName =
                                                          addressData.lastName;
                                                      addressController.number =
                                                          addressData.number;
                                                      addressController.email =
                                                          addressData.email;
                                                      addressController
                                                              .address1 =
                                                          addressData.address1;
                                                      addressController
                                                              .address2 =
                                                          addressData.adress2;
                                                      addressController.state =
                                                          addressData.state;
                                                      addressController
                                                              .pinCode =
                                                          addressData.pincode;
                                                    });
                                                    debugPrint(
                                                        addressData.addressId);
                                                  })
                                            ],
                                          ),
                                          RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: AddressStrings.mobile,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium),
                                                TextSpan(
                                                    text: addressData.number,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge)
                                              ])),
                                          RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: AddressStrings.mobile,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium),
                                                TextSpan(
                                                    text: addressData.email,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge)
                                              ])),
                                          RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        AddressStrings.address1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium),
                                                TextSpan(
                                                    text: addressData.address1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge)
                                              ])),
                                          RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        AddressStrings.address2,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium),
                                                TextSpan(
                                                    text: addressData.adress2,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge)
                                              ])),
                                          RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: AddressStrings.city,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium),
                                                TextSpan(
                                                    text: addressData.cityName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge)
                                              ])),
                                          RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: AddressStrings.state,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium),
                                                TextSpan(
                                                    text: addressData.state,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge)
                                              ])),
                                          RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        AddressStrings.pinCode,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium),
                                                TextSpan(
                                                    text: addressData.pincode,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge)
                                              ])),
                                        ],
                                      )),
                                );
                              }),
                            ),
                          ),
                        ),
                      )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddressFormScreen(apiCall: 0)));
            // Get.to(() => const AddressFormScreen(apiCall: 0));
          },
          child: const Icon(
            Remix.add_circle_line,
            color: Colors.white,
            size: 22,
          ),
        ),
      );
    });
  }
}
