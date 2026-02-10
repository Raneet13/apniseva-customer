import 'package:apniseva/screens/cart/cart_controller/cart_controller.dart';
import 'package:apniseva/model/cart_model/cart_detail_model/cart_details_model.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    super.initState();
    Future.delayed(Duration.zero, () {
      addressController.getCartData();
    });
    _selectedRadioButton =
        int.tryParse(addressController.addressID ?? '-1') ?? -1;
  }

  Future<void> refresh() async {
    return Future.delayed(Duration.zero, () {
      addressController.getCartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = addressController.fetch.value;
      final addressList = addressController
          .cartDetailsDataModel.value.messages?.status?.addressData;

      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Remix.arrow_left_s_line, color: Colors.black),
          ),
          title: Text(
            "My Addresses",
            style: GoogleFonts.outfit(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            if (widget.isSelectingFromCart)
              TextButton(
                onPressed: () {
                  if (addressController.addressID != null) {
                    Navigator.pop(context);
                  } else {
                    Get.snackbar(
                      'Selection Required',
                      "Please select an address to proceed",
                      backgroundColor: Colors.red.withOpacity(0.1),
                      colorText: Colors.red,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  }
                },
                child: Text(
                  "Confirm",
                  style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 3,
                ),
              )
            : addressList == null || addressList.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: refresh,
                    color: primaryColor,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: addressList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final address = addressList[index];
                        return _buildAddressCard(address);
                      },
                    ),
                  ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AddressFormScreen(apiCall: 0),
              ),
            );
          },
          backgroundColor: primaryColor,
          elevation: 4,
          icon: const Icon(Remix.add_line, color: Colors.white),
          label: Text(
            "Add New Address",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Remix.map_pin_user_line,
              size: 64,
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Addresses Found",
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add a new address to get started",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.blueGrey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressDatum address) {
    // Determine if this address is selected
    bool isSelected =
        _selectedRadioButton == int.tryParse(address.addressId ?? '0');

    return GestureDetector(
      onTap: () => _handleAddressSelection(address),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade100,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withOpacity(0.1)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Remix
                        .home_4_line, // You could drive this dynamically if you had a 'type' field
                    color: isSelected ? primaryColor : Colors.blueGrey.shade400,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${address.firstName} ${address.lastName}",
                        style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey.shade900),
                      ),
                      Text(
                        "Home", // Placeholder for address type
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.blueGrey.shade400),
                      ),
                    ],
                  ),
                ),
                if (widget.isSelectingFromCart)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? primaryColor : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
              ],
            ),
            const Divider(height: 32, thickness: 1, color: Color(0xFFF5F5F7)),
            _buildInfoRow(Remix.phone_line, address.number ?? ""),
            const SizedBox(height: 12),
            _buildInfoRow(
              Remix.map_pin_2_line,
              "${address.address1}, ${address.adress2}\n${address.cityName}, ${address.state} - ${address.pincode}",
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editAddress(address),
                    icon: Icon(Remix.edit_line,
                        size: 16, color: Colors.blueGrey.shade700),
                    label: Text("Edit",
                        style: GoogleFonts.poppins(
                            color: Colors.blueGrey.shade700,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                // if (isSelected) ...[
                //   const SizedBox(width: 12),
                //   Container(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 12, vertical: 12),
                //     decoration: BoxDecoration(
                //       color: primaryColor.withOpacity(0.1),
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Icon(Remix.check_line, color: primaryColor),
                //   )
                // ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey.shade400),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.blueGrey.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAddressSelection(AddressDatum addressData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (addressData.addressId != null) {
      preferences.setString(ApiStrings.addressID, addressData.addressId!);

      setState(() {
        // Update local controller state
        addressController.addressID = addressData.addressId;
        _selectedRadioButton = int.tryParse(addressData.addressId!) ?? 0;

        addressController.firstName = addressData.firstName;
        addressController.lastName = addressData.lastName;
        addressController.number = addressData.number;
        addressController.email = addressData.email;
        addressController.address1 = addressData.address1;
        addressController.address2 = addressData.adress2;
        addressController.state = addressData.state;
        addressController.pinCode = addressData.pincode;
      });
      debugPrint("Selected Address ID: ${addressData.addressId}");
    }
  }

  void _editAddress(AddressDatum addressData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (addressData.addressId != null) {
      await preferences.setString(ApiStrings.addressID, addressData.addressId!);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddressFormScreen(
          apiCall: 1,
          addressData: addressData,
        ),
      ),
    );
  }
}
