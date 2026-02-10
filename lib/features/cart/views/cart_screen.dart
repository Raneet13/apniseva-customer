import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../widgets/cart_appbar.dart';
import '../widgets/cart_order_schedule.dart';
import '../widgets/apply_coupon.dart';
import '../widgets/apply_gstbill.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: const CartAppBar(
          title: "Cart",
        ),
        body: controller.fetch.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: const [
                    CartOrderScheduleTotal(),
                    CartApplyCoupon(),
                    ApplyGstbill(),
                  ],
                ),
              ),
      );
    });
  }
}
