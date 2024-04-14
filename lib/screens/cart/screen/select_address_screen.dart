import 'package:apniseva/screens/cart/cart_sections/cart_appbar.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/cart_controller/cart_controller.dart';
import '../../address/widget/address_strings.dart';
import '../../../model/cart_model/cart_detail_model/cart_details_model.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {

  int _selectedRadioButton = 0;

  final addressController = Get.put(CartController());

  @override
  void initState() {
    Future.delayed(Duration.zero,() {
      addressController.getCartData();
    });
    super.initState();
    _selectedRadioButton = -1;
  }

  Future<void> refresh() async {
    return  Future.delayed(Duration.zero,() {
      addressController.getCartData();
    });
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Obx(() {
      return Scaffold(
        appBar: CartAppBar(
          title: AddressStrings.title,
        ),
        body: SafeArea(
            child: addressController.fetch.value == true ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 2.5,
                )
            ): RefreshIndicator(
              onRefresh: refresh,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                  child: Column(
                    children: List.generate(
                        addressController.cartDetailsDataModel.value.messages!.status!.addressData!.length,
                            (index) {
                          AddressDatum addressData = addressController.cartDetailsDataModel.value.messages!.status!.addressData![index];
                          return Card(
                            color: Colors.grey.shade200,
                            child: Container(
                                width: width,
                                padding: const EdgeInsets.only(left: 15, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: AddressStrings.name,
                                                      style: Theme.of(context).textTheme.labelMedium
                                                  ),
                                                  TextSpan(
                                                      text: "${addressData.firstName} ${addressData.lastName}",
                                                      style: Theme.of(context).textTheme.titleLarge
                                                  )
                                                ]
                                            )
                                        ),
                                        Radio<int>(
                                            value: index,
                                            toggleable: true,
                                            groupValue: _selectedRadioButton,
                                            onChanged: (value) async{
                                              SharedPreferences preferences = await SharedPreferences.getInstance();
                                              preferences.setString(ApiStrings.addressID, addressData.addressId!);
                                              // preferences.setString(ApiStrings, value)
                                              setState(() {
                                                _selectedRadioButton = value!;
                                              });
                                            }
                                        )
                                      ],
                                    ),

                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: AddressStrings.mobile,
                                                  style: Theme.of(context).textTheme.labelMedium
                                              ),
                                              TextSpan(
                                                  text: addressData.number,
                                                  style: Theme.of(context).textTheme.titleLarge
                                              )
                                            ]
                                        )
                                    ),

                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: AddressStrings.mobile,
                                                  style: Theme.of(context).textTheme.labelMedium
                                              ),
                                              TextSpan(
                                                  text: addressData.email,
                                                  style: Theme.of(context).textTheme.titleLarge
                                              )
                                            ]
                                        )
                                    ),

                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: AddressStrings.address1,
                                                  style: Theme.of(context).textTheme.labelMedium
                                              ),
                                              TextSpan(
                                                  text: addressData.address1,
                                                  style: Theme.of(context).textTheme.titleLarge
                                              )
                                            ]
                                        )
                                    ),

                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: AddressStrings.address2,
                                                  style: Theme.of(context).textTheme.labelMedium
                                              ),
                                              TextSpan(
                                                  text: addressData.adress2,
                                                  style: Theme.of(context).textTheme.titleLarge
                                              )
                                            ]
                                        )
                                    ),

                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: AddressStrings.city,
                                                  style: Theme.of(context).textTheme.labelMedium
                                              ),
                                              TextSpan(
                                                  text: addressData.cityName,
                                                  style: Theme.of(context).textTheme.titleLarge
                                              )
                                            ]
                                        )
                                    ),

                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: AddressStrings.state,
                                                  style: Theme.of(context).textTheme.labelMedium
                                              ),
                                              TextSpan(
                                                  text: addressData.state,
                                                  style: Theme.of(context).textTheme.titleLarge
                                              )
                                            ]
                                        )
                                    ),

                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: AddressStrings.pinCode,
                                                  style: Theme.of(context).textTheme.labelMedium
                                              ),
                                              TextSpan(
                                                  text: addressData.pincode,
                                                  style: Theme.of(context).textTheme.titleLarge
                                              )
                                            ]
                                        )
                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ),
            )
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              width: width,
              height: 65,
              color: Colors.white,
              alignment: Alignment.center,
              child: PrimaryButton(
                  width: width * 0.95,
                  height: 47, onPressed: () async{
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    String? addressId = preferences.getString(ApiStrings.addressID);
                    debugPrint(addressId);
                    Navigator.pop(context);
                    },
                  child: const Text('Select Address',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600
                    ),
                  ),
              )
          ),
        )
      );
    }
    );
  }
}
