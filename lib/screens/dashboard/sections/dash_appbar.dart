import 'package:apniseva/controller/cart_controller/cart_controller.dart';
import 'package:apniseva/screens/cart/screen/cart_screen.dart';
import 'package:apniseva/screens/splash_screen/widgets/spalsh_string.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_strings/api_strings.dart';
import '../../location/screen/location.dart';

class DashAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DashAppBar({Key? key}) : super(key: key);

  @override
  State<DashAppBar> createState() => _DashAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _DashAppBarState extends State<DashAppBar> {
  final cartController = Get.put(CartController());
  String? cityName;

  Future<String?> getLoc() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? location = preferences.getString(ApiStrings.cityName);
    setState(() {
      cityName = location;
    });
    debugPrint('DashAppBar: $cityName');
    return cityName;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      cartController.getCartData();
    });
    getLoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: widget.preferredSize,
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset(
            SplashStrings.apniSevaLogo,
            height: 55,
            width: 90,
            color: Colors.white,
          ),
          actions: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const GetLocation();
                    });
              },
              child: Container(
                  height: 55,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        cityName ?? 'Khorda',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      )
                    ],
                  )),
            ),
//View Cart Section hide for some reason
            // Obx(() {
            //     return cartController.fetch.value == true && cartController.cartDetailsDataModel.value.status == 400 ?
            //     InkWell(
            //       onTap: (){
            //         Get.to(()=> const CartScreen());
            //       },
            //       child: Container(
            //           height: 55,
            //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //           alignment: Alignment.center,
            //           child: const Icon(Remix.shopping_cart_2_fill)
            //       ),
            //     ):
            //     InkWell(
            //       onTap: (){
            //         Get.to(()=> const CartScreen());
            //       },
            //       child: Container(
            //         height: 55,
            //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //         alignment: Alignment.center,
            //         child: badges.Badge(
            //             position: badges.BadgePosition.topEnd(top: -5, end: -5),
            //             showBadge: cartController.cartDetailsDataModel.value.messages?.status!.allCart! == null ? false : true,
            //             badgeContent: Text(cartController.cartDetailsDataModel.value.messages?.status!.allCart! == null ? '' : cartController.cartDetailsDataModel.value.messages!.status!.allCart!.length.toString(),
            //               style: Theme.of(context).textTheme.bodySmall,
            //             ),
            //             child: const Icon(Remix.shopping_cart_2_fill)
            //         ),
            //       ),
            //     );
            //   }
            // )
          ],
        ));
  }
}
