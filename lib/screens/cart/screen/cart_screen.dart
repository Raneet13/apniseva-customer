// cart_screen.dart
import 'package:apniseva/screens/cart/cart_controller/cart_controller.dart';
import 'package:apniseva/model/cart_model/cart_detail_model/cart_details_model.dart';
import 'package:apniseva/screens/auth/screens/registration_screen.dart';
import 'package:apniseva/screens/cart/cart_sections/cart_order_schedule.dart';
import 'package:apniseva/screens/cart/cart_strings/cart_strings.dart';
import 'package:apniseva/screens/sucessful/screen/sucessfull_screen.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../background/background_service.dart';
import '../../../utils/buttons.dart';
import '../cart_sections/apply_coupon.dart';
import '../cart_sections/apply_gstbill.dart';
import '../cart_sections/cart_appbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:apniseva/utils/color.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _razorpay = Razorpay();
  String error = '';
  final CartController cartController = Get.find<CartController>();

  // ✅ Add a flag to ensure the guest status check only runs once
  bool _initialLoadHandled = false;

  @override
  void initState() {
    super.initState();

    // ✅ Implement guest user check and conditional data loading
    // This will run after the first frame is built, ensuring context is available for navigation.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_initialLoadHandled) {
        _initialLoadHandled = true; // Mark as handled

        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isGuest = prefs.getBool('isGuest') ?? false;

        if (isGuest) {
          // If the user is a guest, redirect to RegistrationScreen
          // Get.offAll removes all previous routes and pushes a new one
          Get.offAll(() => const RegistrationScreen());
          // IMPORTANT: Do not proceed with cart data fetch for guests
          return; // Exit initState callback
        } else {
          // Only fetch cart data if not a guest
          // This ensures actual user cart data is loaded for logged-in users.
          cartController.getCartData();
          cartController.applyCoupon();
        }
      }
    });

    // Existing Razorpay initialization, independent of guest status
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> refresh() async {
    // Check for guest status before refreshing, though the initial check should prevent guests from being here
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isGuest = prefs.getBool('isGuest') ?? false;
    if (isGuest) {
      Get.offAll(() => const RegistrationScreen());
      return;
    }

    return Future.delayed(Duration.zero, () {
      cartController
        ..getCartData()
        ..applyCoupon();
    });
  }

  void openCheckout() async {
    // ✅ Add guest check before checkout
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isGuest = prefs.getBool('isGuest') ?? false;
    if (isGuest) {
      Get.snackbar('Login Required', 'Please login to proceed with checkout.',
          backgroundColor: Colors.red[50], colorText: Colors.red);
      Get.offAll(() => const RegistrationScreen());
      return;
    }

    var options = {
      'key': cartController.razorPayKey,
      "amount": int.parse(cartController.cartTtalAmount.toString()) * 100, //
      "currency": "INR",
      'name': cartController.firstName,
      'description': cartController.userId.toString(),
      'prefill': {
        'contact': cartController.number,
        'email': cartController.email
      },
    };

    try {
      await initialService();
      _razorpay.open(options);
    } catch (e) {
      print(e);
      // Handle error if Razorpay fails to open, e.g., network issues
      Get.snackbar(
          'Payment Error', 'Could not initiate payment. Please try again.',
          backgroundColor: Colors.red[50], colorText: Colors.red);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    cartController.paid_amount = int.parse(cartController.price![0]);
    cartController.payment_id = response.paymentId.toString();

    // Duplicate line, keeping for consistency with original code
    cartController.paid_amount = int.parse(cartController.price![0]);
    cartController.payment_id = response.paymentId.toString();

    Future.delayed(Duration.zero, () {
      cartController.checkOut();
      refresh();
    });
    stopBackgroundService();
    Fluttertoast.showToast(msg: "SUCCESS: ");
    Get.offAll(
        () => const SuccessfulScreen()); // Added navigation to success screen
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    stopBackgroundService();
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message}");
    Get.snackbar('Payment Failed',
        response.message ?? 'Payment process was interrupted.',
        backgroundColor: Colors.red[50], colorText: Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    stopBackgroundService();
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Obx(() {
      // The guest redirection in initState should prevent this from being shown to guests.
      // However, if due to some unexpected state, cartController.fetch.value is true,
      // it means data is trying to load, which should only happen for logged-in users.
      if (cartController.fetch.value) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3,
            ),
          ),
        );
      }

      final cartData =
          cartController.cartDetailsDataModel.value.messages?.status?.allCart ??
              [];

      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: CartAppBar(title: CartStrings.title),
        body: cartData.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: refresh,
                color: primaryColor,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart Items Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Items in Cart",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${cartData.length} Items",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Cart Items List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartData.length,
                          itemBuilder: (context, index) {
                            return _buildCartItem(
                                context, cartData[index], index);
                          },
                        ),

                        const SizedBox(height: 24),

                        // Sections Header
                        Text(
                          "Delivery & Booking",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Address & Schedule Section
                        const CartOrderScheduleTotal(),

                        const SizedBox(height: 16),

                        // Offers & GST Section
                        const CartApplyCoupon(),
                        const ApplyGstbill(),

                        const SizedBox(height: 24),

                        // Payment Method Header
                        Text(
                          "Payment Method",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Payment Methods
                        _buildPaymentMethodSelector(),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
        bottomNavigationBar: cartData.isEmpty
            ? const SizedBox.shrink()
            : _buildBottomAction(width),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Remix.shopping_cart_2_line,
                size: 80, color: primaryColor.withOpacity(0.3)),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(
              color: Colors.blueGrey.shade900,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Looks like you haven\'t added\nany services yet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.blueGrey.shade400,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: PrimaryButton(
              width: 200,
              height: 50,
              onPressed: () {
                // If a guest somehow reaches this state, ensure they go back to the appropriate screen
                // For a logged-in user, this correctly goes to the bottom nav bar.
                // For a guest, the initState redirect should have fired, but as a fallback:
                // If this button is reached by a guest (which shouldn't happen with the initState logic)
                // it would be better to send them to the login screen.
                // However, as per your strict "no changes" request for this part,
                // we'll keep the original navigation for logged-in users.
                Get.offAll(const BottomNavBar());
              },
              child: const Text(
                "Keep Exploring",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, AllCart item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Image Section
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    "${ApiEndPoint.imageAPI}/${item.image}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/images/no_image.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Content Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.servicename ?? "",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey.shade900,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              // ✅ Add guest check before item removal
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              bool isGuest = prefs.getBool('isGuest') ?? false;
                              if (isGuest) {
                                Get.snackbar('Login Required',
                                    'Please login to manage cart.',
                                    backgroundColor: Colors.red[50],
                                    colorText: Colors.red);
                                Get.offAll(() => const RegistrationScreen());
                                return;
                              }

                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.setString(
                                  ApiStrings.cartID, item.cartId!);
                              cartController.removeItem();
                              refresh();
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Remix.delete_bin_line,
                                  color: Colors.redAccent, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${item.price}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Qty: ",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey.shade300,
                                ),
                              ),
                              Text(
                                item.qty ?? "0",
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blueGrey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        _buildPaymentOption(
          id: 'cash',
          title: CartStrings.pod,
          icon: Remix.hand_coin_line,
          description: "Pay conveniently after service delivery",
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          id: 'online',
          title: CartStrings.payOnline,
          icon: Remix.bank_card_line,
          description: "Fast and secure payment with Razorpay",
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required IconData icon,
    required String description,
  }) {
    final bool isSelected = cartController.paymentMode == id;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? primaryColor : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // ✅ Add guest check before selecting payment mode
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool isGuest = prefs.getBool('isGuest') ?? false;
            if (isGuest) {
              Get.snackbar(
                  'Login Required', 'Please login to select payment method.',
                  backgroundColor: Colors.red[50], colorText: Colors.red);
              Get.offAll(() => const RegistrationScreen());
              return;
            }
            setState(() => cartController.paymentMode = id);
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withOpacity(0.1)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? primaryColor : Colors.blueGrey.shade300,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.blueGrey.shade900
                              : Colors.blueGrey.shade600,
                        ),
                      ),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Remix.checkbox_circle_fill,
                      color: primaryColor, size: 24)
                else
                  Icon(Remix.checkbox_blank_circle_line,
                      color: Colors.grey.shade300, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(double width) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: cartController.cartDetailsDataModel.value.status == 200
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: PrimaryButton(
                width: width,
                height: 56,
                onPressed: () async {
                  // ✅ Add guest check before confirming booking/checkout
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  bool isGuest = prefs.getBool('isGuest') ?? false;
                  if (isGuest) {
                    Get.snackbar('Login Required',
                        'Please login to confirm your booking.',
                        backgroundColor: Colors.red[50], colorText: Colors.red);
                    Get.offAll(() => const RegistrationScreen());
                    return;
                  }

                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String? address = preferences.getString(ApiStrings.addressID);
                  if (address == null) {
                    Get.snackbar('Address', 'Please Select address',
                        colorText: Colors.white,
                        backgroundColor: Colors.orange);
                  } else if (cartController.dateController.text.isEmpty) {
                    Get.snackbar('Date', 'Select Date',
                        colorText: Colors.white,
                        backgroundColor: Colors.orange);
                  } else if (cartController.timeController.text.isEmpty) {
                    Get.snackbar('Time', 'Select Time',
                        colorText: Colors.white,
                        backgroundColor: Colors.orange);
                  } else if (cartController.paymentMode == null) {
                    Get.snackbar('Payment', 'Select Payment method',
                        colorText: Colors.white,
                        backgroundColor: Colors.orange);
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
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
          : PrimaryButton(
              width: width,
              height: 56,
              onPressed: () async {
                // This button is shown when the cart is empty.
                // For a logged-in user, navigating to BottomNavBar is fine.
                // For a guest, they should ideally not be on this screen due to the initState check.
                // However, as a failsafe or if they somehow became a guest after emptying cart,
                // we can perform an additional check here.
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool isGuest = prefs.getBool('isGuest') ?? false;
                if (isGuest) {
                  Get.offAll(() => const RegistrationScreen());
                } else {
                  Get.offAll(() => const BottomNavBar());
                }
              },
              child: Text(
                'Browse Services',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
    );
  }
}
