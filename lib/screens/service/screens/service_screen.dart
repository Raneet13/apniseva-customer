import 'package:apniseva/controller/cart_controller/cart_controller.dart';
import 'package:apniseva/controller/service_controller/service_controller.dart';
import 'package:apniseva/model/service_model/service_model.dart';
import 'package:apniseva/screens/auth/screens/registration_screen.dart';
import 'package:apniseva/screens/service/sections/service_appbar.dart';
import 'package:apniseva/screens/service/sections/service_strings.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cart/screen/cart_screen.dart';

class ServiceScreen extends StatefulWidget {
  final String serviceName;
  const ServiceScreen({Key? key, this.serviceName = "Service"})
      : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final serviceController = Get.put(ServiceController());
  final addToCartController = Get.find<CartController>();
  bool isGuest = false;

  @override
  void initState() {
    checkGuestStatus();
    service();
    super.initState();
  }

  checkGuestStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isGuest = pref.getBool('isGuest') ?? false;
    });
  }

  service() async {
    serviceController.getService();
    if (!isGuest) {
      await addToCartController.addToCart();
    }
  }

  refresh() async {
    Future.delayed(Duration.zero, () async {
      serviceController.getService();
      if (!isGuest) {
        await addToCartController.addToCart();
        await addToCartController.getCartData();
      }
    });
  }

  bool cartTrueFalse(String serviceName) {
    if (isGuest) return false;
    final CartController cartController = Get.find<CartController>();
    bool cartTrue = false;
    if (cartController.cartDetailsDataModel.value.messages?.status?.allCart !=
        null) {
      for (var item in cartController
          .cartDetailsDataModel.value.messages!.status!.allCart!) {
        if (serviceName == item.servicename) {
          cartTrue = true;
          break;
        }
      }
    }
    return cartTrue;
  }

  String itemQty(String productId) {
    if (isGuest) return "0";
    final CartController cartController = Get.find<CartController>();
    String qty = "0";
    if (cartController.cartDetailsDataModel.value.messages?.status?.allCart !=
        null) {
      for (var item in cartController
          .cartDetailsDataModel.value.messages!.status!.allCart!) {
        if (productId == item.productId) {
          qty = item.qty.toString();
          break;
        }
      }
    }
    return qty;
  }

  Future<String?> checkCartId(String productId) async {
    if (isGuest) return null;
    final CartController cartController = Get.find<CartController>();
    if (cartController.cartDetailsDataModel.value.messages?.status?.allCart !=
        null) {
      for (var item in cartController
          .cartDetailsDataModel.value.messages!.status!.allCart!) {
        if (productId == item.productId) {
          return item.cartId;
        }
      }
    }
    return null;
  }

  void _showFullContent(BuildContext context, String htmlcontent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Service Details",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Html(
                    data: htmlcontent,
                    style: {
                      "body": Style(
                        color: Colors.blueGrey.shade700,
                        fontSize: FontSize(15.0),
                        lineHeight: const LineHeight(1.6),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Obx(
          () {
        if (serviceController.isLoading.value) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 3,
              ),
            ),
          );
        }

        final serviceData = serviceController
            .serviceDataModel.value.messages?.status?.serviceList ??
            [];

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: ServiceAppBar(title: ServiceStrings.serviceName),
          // FIX 2: Use bottomNavigationBar with SafeArea so it never overlaps
          // the device's gesture bar / home indicator.
          bottomNavigationBar: isGuest
              ? null
              : _buildBottomCartBar(context, cartController),
          body: serviceData.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            // Keep a comfortable bottom padding so last card isn't
            // hidden behind the floating cart bar.
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: serviceData.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(
                  context, serviceData[index], cartController);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No Services Found',
            style: TextStyle(
              color: Colors.blueGrey.shade300,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
      BuildContext context, ServiceList item, CartController cartController) {
    final bool isInCart = cartTrueFalse(item.serviceName!);
    final String qty = itemQty(item.serviceId.toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showFullContent(context, item.serviceDetails ?? ""),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              // FIX 1: Removed IntrinsicHeight — it caused the Column inside
              // to be tightly constrained, leading to the 1px overflow.
              // crossAxisAlignment drives alignment without IntrinsicHeight.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section — fixed square size, no longer drives row height
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 110,
                    height: 110,
                    color: Colors.blue.shade50.withOpacity(0.4),
                    child: Image.network(
                      "${ApiEndPoint.imageAPI}/${item.serviceImage}",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            color: primaryColor.withOpacity(0.3),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            "assets/images/no_image.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Content Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // FIX 1: mainAxisSize.min so the Column only takes the
                    // space its children actually need — no more overflow.
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.serviceName ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey.shade900,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${item.amount}',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (item.serviceDetails != null &&
                          item.serviceDetails!.isNotEmpty)
                        Html(
                          data: item.serviceDetails!.length > 80
                              ? "${item.serviceDetails!.substring(0, 75)}..."
                              : item.serviceDetails!,
                          style: {
                            "body": Style(
                              color: Colors.blueGrey.shade500,
                              fontSize: FontSize(11.0),
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          },
                        ),
                      // FIX 1: Replaced Spacer() with a small fixed gap.
                      // Spacer() inside an unbounded (min) column causes
                      // assertion errors; a fixed gap is safe and sufficient.
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child:
                        _buildCartControls(context, item, isInCart, qty),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartControls(
      BuildContext context, ServiceList item, bool isInCart, String qty) {
    if (!isInCart) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withOpacity(0.8)],
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (isGuest) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please login first to add products"),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(ApiStrings.serviceID, item.serviceId!);
              prefs.setString(ApiStrings.catID, item.catId!);
              prefs.setString(ApiStrings.productQty, "1");
              addToCartController.addToCart();
              refresh();
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: const Text(
                "ADD",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconButton(
            icon: Icons.remove,
            onPressed: () async {
              int currentQty = int.parse(qty);
              if (currentQty <= 1) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? cartId = await checkCartId(item.serviceId.toString());
                if (cartId != null) {
                  prefs.setString(ApiStrings.cartID, cartId);
                  addToCartController.deletItemFrmCart();
                }
              } else {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString(ApiStrings.serviceID, item.serviceId!);
                prefs.setString(ApiStrings.catID, item.catId!);
                prefs.setString(
                    ApiStrings.productQty, (currentQty - 1).toString());
                addToCartController.addToCart();
              }
              refresh();
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              qty,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: primaryColor,
              ),
            ),
          ),
          _buildIconButton(
            icon: Icons.add,
            isPrimary: true,
            onPressed: () async {
              int currentQty = int.parse(qty);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(ApiStrings.serviceID, item.serviceId!);
              prefs.setString(ApiStrings.catID, item.catId!);
              prefs.setString(
                  ApiStrings.productQty, (currentQty + 1).toString());
              addToCartController.addToCart();
              refresh();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon,
        required VoidCallback onPressed,
        bool isPrimary = false}) {
    return Material(
      color: isPrimary ? primaryColor : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: isPrimary ? 2 : 0,
      shadowColor: primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon,
              color: isPrimary ? Colors.white : primaryColor, size: 18),
        ),
      ),
    );
  }

  Widget _buildBottomCartBar(
      BuildContext context, CartController cartController) {
    if (cartController.cartDetailsDataModel.value.messages?.status?.allCart ==
        null ||
        cartController
            .cartDetailsDataModel.value.messages!.status!.allCart!.isEmpty) {
      return const SizedBox.shrink();
    }

    final int count = cartController
        .cartDetailsDataModel.value.messages!.status!.allCart!.length;

    // FIX 2: Wrap in SafeArea so the bar sits above the device's home
    // indicator / gesture nav bar on all Android & iOS devices.
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withBlue(200)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => Get.to(() => const CartScreen()),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Remix.shopping_bag_3_line,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$count ${count == 1 ? 'Item' : 'Items'} Added",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "View Cart Details",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  "GO TO CART",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}