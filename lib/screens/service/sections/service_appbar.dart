import 'package:apniseva/screens/cart/screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:badges/badges.dart' as badges;

import '../../../controller/cart_controller/cart_controller.dart';
import '../../../utils/color.dart';

class ServiceAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const ServiceAppBar({Key? key, required this.title}) : super(key: key);

  @override
  State<ServiceAppBar> createState() => _ServiceAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _ServiceAppBarState extends State<ServiceAppBar> {
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: widget.preferredSize,
        child: AppBar(
          titleSpacing: 0,
          elevation: 0,
          leadingWidth: 30,
          automaticallyImplyLeading: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Remix.arrow_left_s_line,
                color: Colors.white,
              )),
          title: Text(
            widget.title,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            Obx(() {
              return cartController.fetch.value == true &&
                      cartController.cartDetailsDataModel.value.status == 400
                  ? InkWell(
                      onTap: () {
                        Get.to(() => const CartScreen());
                      },
                      child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          alignment: Alignment.center,
                          child: const Icon(
                            Remix.shopping_cart_2_fill,
                            color: Colors.white,
                          )),
                    )
                  : InkWell(
                      onTap: () {
                        Get.to(() => const CartScreen());
                      },
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        alignment: Alignment.center,
                        child: badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: -5, end: -5),
                            showBadge: cartController.cartDetailsDataModel.value
                                        .messages?.status!.allCart ==
                                    null
                                ? false
                                : true,
                            badgeContent: Text(
                              cartController.cartDetailsDataModel.value.messages
                                          ?.status!.allCart ==
                                      null
                                  ? ''
                                  : cartController.cartDetailsDataModel.value
                                      .messages!.status!.allCart!.length
                                      .toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            child: const Icon(
                              Remix.shopping_cart_2_fill,
                              color: Colors.white,
                            )),
                      ),
                    );
            })
          ],
          backgroundColor: primaryColor,
        ));
  }
}
