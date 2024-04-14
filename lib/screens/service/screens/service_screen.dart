import 'package:apniseva/controller/cart_controller/cart_controller.dart';
import 'package:apniseva/controller/service_controller/service_controller.dart';
import 'package:apniseva/model/service_model/service_model.dart';
import 'package:apniseva/screens/service/sections/service_appbar.dart';
import 'package:apniseva/screens/service/sections/service_strings.dart';
import 'package:apniseva/utils/api_endpoint_strings/api_endpoint_strings.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/cart_model/cart_detail_model/cart_details_model.dart';

class ServiceScreen extends StatefulWidget {
  final String serviceName;
  const ServiceScreen({Key? key, this.serviceName = "Service"})
      : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool addedItem = false;
  final serviceController = Get.put(ServiceController());
  final addToCartController = Get.find<CartController>();

  @override
  void initState() {
    // Future.delayed(Duration.zero, () {
    //   serviceController.getService();
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    service();
    super.initState();
  }

  service() async {
    serviceController.getService();
    await addToCartController.addToCart();
  }

  refresh() async {
    Future.delayed(Duration.zero, () async {
      serviceController.getService();
      await addToCartController.addToCart();
      await addToCartController.getCartData();
    });
  }

  cartTrueFalse(String serviceName) {
    final CartController cartController = Get.find<CartController>();

    bool cartTrue = false;
    for (var i = 0;
        i <
            cartController
                .cartDetailsDataModel.value.messages!.status!.allCart!.length;
        i++) {
      if (serviceName ==
          cartController.cartDetailsDataModel.value.messages!.status!
              .allCart![i].servicename) {
        cartTrue = true;
      }
    }
    return cartTrue;
  }

  String itemQty(String productId) {
    final CartController cartController = Get.find<CartController>();
    String qty = "0";
    for (var i = 0;
        i <
            cartController
                .cartDetailsDataModel.value.messages!.status!.allCart!.length;
        i++) {
      if (productId ==
          cartController.cartDetailsDataModel.value.messages!.status!
              .allCart![i].productId) {
        qty = cartController
            .cartDetailsDataModel.value.messages!.status!.allCart![i].qty
            .toString();
      }
    }
    return qty;
  }

  checkCartId(String productId) {
    final CartController cartController = Get.find<CartController>();

    for (var i = 0;
        i <
            cartController
                .cartDetailsDataModel.value.messages!.status!.allCart!.length;
        i++) {
      if (productId ==
          cartController.cartDetailsDataModel.value.messages!.status!
              .allCart![i].productId) {
        print(cartController
            .cartDetailsDataModel.value.messages!.status!.allCart![i].cartId);
        return cartController
            .cartDetailsDataModel.value.messages!.status!.allCart![i].cartId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // print(serviceController.serviceDataModel.value.messages?.status!
        //     .toJson());
        return serviceController.isLoading.value == true
            ? Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 1.5,
                  ),
                ),
              )
            : Scaffold(
                appBar: ServiceAppBar(title: ServiceStrings.serviceName),
                body: serviceController.serviceDataModel.value.messages?.status!
                                .serviceList! ==
                            null ||
                        serviceController.serviceDataModel.value.messages!
                            .status!.serviceList!.isEmpty
                    ? const Center(
                        child: Text(
                          'No Service Found',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          // child: Obx(() {
                          //   return ListView.builder(
                          //       shrinkWrap: true,
                          //       itemCount: serviceController.serviceDataModel.value
                          //           .messages!.status!.serviceList!.length,
                          //       itemBuilder: (context, index) {
                          //         List<ServiceList> serviceData = serviceController
                          //             .serviceDataModel
                          //             .value
                          //             .messages!
                          //             .status!
                          //             .serviceList!;
                          //         // addToCartController.cartTrueFalse(
                          //         //     serviceData[index].serviceName!);
                          //         return Card(
                          //           elevation: 1.4,
                          //           child: ListTile(
                          //             shape: RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.circular(8.0)),
                          //             tileColor: Colors.grey.shade200,
                          //             contentPadding: const EdgeInsets.symmetric(
                          //                 horizontal: 5.0),
                          //             leading: ClipRRect(
                          //               borderRadius: BorderRadius.circular(8.0),
                          //               child: Container(
                          //                 height: 40,
                          //                 width: 40,
                          //                 padding: const EdgeInsets.all(5.0),
                          //                 child: Image.network(
                          //                   '${ApiEndPoint.imageAPI}/${serviceData[index].serviceImage}',
                          //                   fit: BoxFit.contain,
                          //                 ),
                          //               ),
                          //             ),
                          //             title: Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceBetween,
                          //               children: [
                          //                 Flexible(
                          //                   child: SizedBox(
                          //                     child: Text(
                          //                       serviceData[index].serviceName ??
                          //                           "",
                          //                       style: Theme.of(context)
                          //                           .textTheme
                          //                           .labelMedium!
                          //                           .copyWith(
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 11,
                          //                           ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 Text(' ₹${serviceData[index].amount}',
                          //                     style: Theme.of(context)
                          //                         .textTheme
                          //                         .bodyMedium),
                          //               ],
                          //             ),
                          //             subtitle: Text(
                          //               serviceData[index].serviceDetails!,
                          //               maxLines: 1,
                          //               overflow: TextOverflow.ellipsis,
                          //               style:
                          //                   Theme.of(context).textTheme.titleSmall,
                          //             ),
                          //             trailing: cartTrueFalse(
                          //                     serviceData[index].serviceName!)
                          //                 ? SizedBox()
                          //                 : Row(
                          //                     mainAxisSize: MainAxisSize.min,
                          //                     children: [
                          //                       IconButton(
                          //                         onPressed: () {
                          //                           if (serviceData[index]
                          //                                   .itemQuantity >
                          //                               0) {
                          //                             serviceData[index]
                          //                                 .itemQuantity--;
                          //                             setState(() {});
                          //                           }
                          //                         },
                          //                         icon: Icon(
                          //                           Icons.remove_circle,
                          //                           color: primaryColor,
                          //                         ),
                          //                       ),
                          //                       Text(
                          //                         "${serviceData[index].itemQuantity}",
                          //                       ),
                          //                       IconButton(
                          //                         onPressed: () {
                          //                           serviceData[index]
                          //                               .itemQuantity++;
                          //                           setState(() {});
                          //                         },
                          //                         icon: Icon(
                          //                           Icons.add_circle,
                          //                           color: primaryColor,
                          //                         ),
                          //                       ),
                          //                       InkWell(
                          //                         onTap: () async {
                          //                           // SharedPreferences preferences =
                          //                           //     await SharedPreferences
                          //                           //         .getInstance();
                          //                           // preferences.setString(
                          //                           //     ApiStrings.serviceID,
                          //                           //     serviceData[index].serviceId!);
                          //                           // preferences.setString(
                          //                           //     ApiStrings.catID,
                          //                           //     serviceData[index].catId!);
                          //                           // preferences.setString(
                          //                           //     ApiStrings.productQty,
                          //                           //     "${serviceData[index].itemQuantity}");
                          //                           // addedItem =
                          //                           //     await addToCartController
                          //                           //         .addToCart();
                          //                           // debugPrint(
                          //                           //     "${addedItem.toString()} this is the debug print");
                          //                           // print(
                          //                           //     "Ths is the cart it of your product ${serviceData[index].serviceName}");
                          //                           print(addToCartController
                          //                               .cartTrueFalse(
                          //                                   serviceData[index]
                          //                                       .serviceName!));
                          //                           // await addToCartController
                          //                           //         .cartTrueFalse(
                          //                           //             serviceData[index]
                          //                           //                 .serviceName!)
                          //                           //     ? print(
                          //                           //         "This car item is add on the cart")
                          //                           //     : print(
                          //                           //         "The product not available on the cart section");
                          //                           // .then((v) => print(
                          //                           //     "${v} Thisi is the future tye of cart added on the addt cart item or not"));
                          //                           // print(
                          //                           //     "${} ");
                          //                           // Future.delayed(Duration.zero, () {
                          //                           //   addToCartController.addToCart();
                          //                           // });
                          //                           refresh();
                          //                         },
                          //                         child: Container(
                          //                           height: 40,
                          //                           width: 40,
                          //                           alignment: Alignment.center,
                          //                           decoration: BoxDecoration(
                          //                               color: primaryColor,
                          //                               borderRadius:
                          //                                   BorderRadius.circular(
                          //                                       8.0)),
                          //                           child: Icon(
                          //                             Icons
                          //                                 .add_shopping_cart_rounded,
                          //                             color: Colors.white,
                          //                             size: Theme.of(context)
                          //                                 .textTheme
                          //                                 .headlineLarge!
                          //                                 .fontSize,
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //             // : InkWell(
                          //             //     onTap: () async {
                          //             //       // SharedPreferences preferences =
                          //             //       //     await SharedPreferences
                          //             //       //         .getInstance();
                          //             //       // preferences.setString(
                          //             //       //     ApiStrings.serviceID,
                          //             //       //     serviceData[index].serviceId!);
                          //             //       // preferences.setString(
                          //             //       //     ApiStrings.catID,
                          //             //       //     serviceData[index].catId!);
                          //             //       // preferences.setString(
                          //             //       //     ApiStrings.productQty,
                          //             //       //     "${serviceData[index].itemQuantity}");
                          //             //       // addedItem =
                          //             //       //     await addToCartController
                          //             //       //         .addToCart();
                          //             //       // debugPrint(
                          //             //       //     "${addedItem.toString()} this is the debug print");
                          //             //       // print(
                          //             //       //     "Ths is the cart it of your product ${serviceData[index].serviceName}");
                          //             //       await addToCartController
                          //             //               .CartTrueFalse(
                          //             //                   serviceData[index]
                          //             //                       .serviceName!)
                          //             //           ? print(
                          //             //               "This car item is add on the cart")
                          //             //           : print(
                          //             //               "The product not available on the cart section");
                          //             //       // .then((v) => print(
                          //             //       //     "${v} Thisi is the future tye of cart added on the addt cart item or not"));
                          //             //       // print(
                          //             //       //     "${} ");
                          //             //       // Future.delayed(Duration.zero, () {
                          //             //       //   addToCartController.addToCart();
                          //             //       // });
                          //             //       refresh();
                          //             //     },
                          //             //     child: Container(
                          //             //       height: 40,
                          //             //       width: 40,
                          //             //       alignment: Alignment.center,
                          //             //       decoration: BoxDecoration(
                          //             //           color: primaryColor,
                          //             //           borderRadius:
                          //             //               BorderRadius.circular(
                          //             //                   8.0)),
                          //             //       child: Icon(
                          //             //         Icons.add_shopping_cart_rounded,
                          //             //         color: Colors.white,
                          //             //         size: Theme.of(context)
                          //             //             .textTheme
                          //             //             .headlineLarge!
                          //             //             .fontSize,
                          //             //       ),
                          //             //     ),
                          //             //   ),
                          //           ),
                          //         );
                          //       });
                          // }),

                          child: Column(
                            children: List.generate(
                              serviceController.serviceDataModel.value.messages!
                                  .status!.serviceList!.length,
                              (index) {
                                List<ServiceList> serviceData =
                                    serviceController.serviceDataModel.value
                                        .messages!.status!.serviceList!;
                                return Card(
                                  elevation: 1.4,
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    tileColor: Colors.grey.shade200,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.network(
                                          '${ApiEndPoint.imageAPI}/${serviceData[index].serviceImage}',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            child: Text(
                                              serviceData[index].serviceName ??
                                                  "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Text(' ₹${serviceData[index].amount}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                      ],
                                    ),
                                    subtitle: Text(
                                      serviceData[index].serviceDetails!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    trailing: SizedBox(
                                      width: 105,
                                      child: cartTrueFalse(
                                              serviceData[index].serviceName!)
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    int itemQnty = int.parse(
                                                        itemQty(
                                                            serviceData[index]
                                                                .serviceId
                                                                .toString()));
                                                    int subqty = itemQnty - 1;
                                                    if (itemQnty <= 1) {
                                                      SharedPreferences
                                                          preferences =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      // print("! or 0");
                                                      // preferences.setString(
                                                      //     ApiStrings.serviceID,
                                                      //     serviceData[index]
                                                      //         .serviceId!);
                                                      preferences.setString(
                                                          ApiStrings.cartID,
                                                          await checkCartId(
                                                              serviceData[index]
                                                                  .serviceId
                                                                  .toString()));
                                                      // var pr = await preferences
                                                      //     .getString(
                                                      //         'ApiStrings.catID');
                                                      // print(pr);
                                                      // print(checkCartId(
                                                      //     serviceData[index]
                                                      //         .serviceId
                                                      //         .toString()));
                                                      // preferences.setString(
                                                      //     ApiStrings.productQty,
                                                      //     subqty
                                                      //         .toString()); //serviceData[index].itemQuantity - 1
                                                      Future.delayed(
                                                          Duration.zero, () {
                                                        addToCartController
                                                            .deletItemFrmCart();
                                                      });
                                                      List<AllCart>? cartData =
                                                          addToCartController
                                                              .cartDetailsDataModel
                                                              .value
                                                              .messages!
                                                              .status!
                                                              .allCart!;
                                                      cartData.removeAt(index);
                                                      refresh();

                                                      //  setState(() {});
                                                    } else {
                                                      SharedPreferences
                                                          preferences =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      preferences.setString(
                                                          ApiStrings.serviceID,
                                                          serviceData[index]
                                                              .serviceId!);
                                                      preferences.setString(
                                                          ApiStrings.catID,
                                                          serviceData[index]
                                                              .catId!);
                                                      preferences.setString(
                                                          ApiStrings.productQty,
                                                          subqty.toString()); //

                                                      Future.delayed(
                                                          Duration.zero, () {
                                                        addToCartController
                                                            .addToCart();
                                                      });

                                                      // cartData.removeAt(index);
                                                      refresh();
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.remove_circle,
                                                    color: primaryColor,
                                                  ),
                                                ),

                                                Text(
                                                  itemQty(serviceData[index]
                                                      .serviceId
                                                      .toString()),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    int addqty = int.parse(
                                                            itemQty(serviceData[
                                                                    index]
                                                                .serviceId
                                                                .toString())) +
                                                        1;
                                                    SharedPreferences
                                                        preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    preferences.setString(
                                                        ApiStrings.serviceID,
                                                        serviceData[index]
                                                            .serviceId!);
                                                    preferences.setString(
                                                        ApiStrings.catID,
                                                        serviceData[index]
                                                            .catId!);
                                                    preferences.setString(
                                                        ApiStrings.productQty,
                                                        addqty.toString()); //

                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      addToCartController
                                                          .addToCart();
                                                    });

                                                    // serviceData[index]
                                                    //     .itemQuantity++;
                                                    refresh();
                                                    // setState(() {});
                                                  },
                                                  icon: Icon(
                                                    Icons.add_circle,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                // InkWell(
                                                //   onTap: () async {
                                                //     SharedPreferences
                                                //         preferences =
                                                //         await SharedPreferences
                                                //             .getInstance();
                                                //     preferences.setString(
                                                //         ApiStrings.serviceID,
                                                //         serviceData[index]
                                                //             .serviceId!);
                                                //     preferences.setString(
                                                //         ApiStrings.catID,
                                                //         serviceData[index]
                                                //             .catId!);
                                                //     preferences.setString(
                                                //         ApiStrings.productQty,
                                                //         "${serviceData[index].itemQuantity}");
                                                //     // addedItem =
                                                //     //     await addToCartController
                                                //     //         .addToCart();
                                                //     // debugPrint(
                                                //     //     "${addedItem.toString()} this is the debug print");
                                                //     // print(
                                                //     //     "Ths is the cart it of your product ${serviceData[index].serviceName}");
                                                //     // print(addToCartController
                                                //     //     .cartTrueFalse(
                                                //     //         serviceData[index]
                                                //     //             .serviceName!));
                                                //     // await addToCartController
                                                //     //         .cartTrueFalse(
                                                //     //             serviceData[index]
                                                //     //                 .serviceName!)
                                                //     //     ? print(
                                                //     //         "This car item is add on the cart")
                                                //     //     : print(
                                                //     //         "The product not available on the cart section");
                                                //     // .then((v) => print(
                                                //     //     "${v} Thisi is the future tye of cart added on the addt cart item or not"));
                                                //     // print(
                                                //     //     "${} ");
                                                //     Future.delayed(Duration.zero,
                                                //         () {
                                                //       addToCartController
                                                //           .addToCart();
                                                //     });
                                                //     refresh();
                                                //   },
                                                //   child: Container(
                                                //     height: 40,
                                                //     width: 40,
                                                //     alignment: Alignment.center,
                                                //     decoration: BoxDecoration(
                                                //         color: primaryColor,
                                                //         borderRadius:
                                                //             BorderRadius.circular(
                                                //                 8.0)),
                                                //     child: Icon(
                                                //       Icons
                                                //           .add_shopping_cart_rounded,
                                                //       color: Colors.white,
                                                //       size: Theme.of(context)
                                                //           .textTheme
                                                //           .headlineLarge!
                                                //           .fontSize,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: InkWell(
                                                onTap: () async {
                                                  SharedPreferences
                                                      preferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  preferences.setString(
                                                      ApiStrings.serviceID,
                                                      serviceData[index]
                                                          .serviceId!);
                                                  preferences.setString(
                                                      ApiStrings.catID,
                                                      serviceData[index]
                                                          .catId!);
                                                  preferences.setString(
                                                      ApiStrings.productQty,
                                                      "${serviceData[index].itemQuantity}");
                                                  // addedItem =
                                                  //     await addToCartController
                                                  //         .addToCart();
                                                  // debugPrint(
                                                  //     "${addedItem.toString()} this is the debug print");
                                                  // print(
                                                  //     "Ths is the cart it of your product ${serviceData[index].serviceName}");
                                                  // print(addToCartController
                                                  //     .cartTrueFalse(
                                                  //         serviceData[index]
                                                  //             .serviceName!));
                                                  // await addToCartController
                                                  //         .cartTrueFalse(
                                                  //             serviceData[index]
                                                  //                 .serviceName!)
                                                  //     ? print(
                                                  //         "This car item is add on the cart")
                                                  //     : print(
                                                  //         "The product not available on the cart section");
                                                  // .then((v) => print(
                                                  //     "${v} Thisi is the future tye of cart added on the addt cart item or not"));
                                                  // print(
                                                  //     "${} ");
                                                  Future.delayed(Duration.zero,
                                                      () {
                                                    addToCartController
                                                        .addToCart();
                                                  });
                                                  refresh();
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  margin: EdgeInsets.only(
                                                      left: 20, right: 20),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  child: Text(
                                                    "Add",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headlineSmall!
                                                              .fontSize,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),

                                    // : InkWell(
                                    //     onTap: () async {
                                    //       // SharedPreferences preferences =
                                    //       //     await SharedPreferences
                                    //       //         .getInstance();
                                    //       // preferences.setString(
                                    //       //     ApiStrings.serviceID,
                                    //       //     serviceData[index].serviceId!);
                                    //       // preferences.setString(
                                    //       //     ApiStrings.catID,
                                    //       //     serviceData[index].catId!);
                                    //       // preferences.setString(
                                    //       //     ApiStrings.productQty,
                                    //       //     "${serviceData[index].itemQuantity}");
                                    //       // addedItem =
                                    //       //     await addToCartController
                                    //       //         .addToCart();
                                    //       // debugPrint(
                                    //       //     "${addedItem.toString()} this is the debug print");
                                    //       // print(
                                    //       //     "Ths is the cart it of your product ${serviceData[index].serviceName}");
                                    //       await addToCartController
                                    //               .CartTrueFalse(
                                    //                   serviceData[index]
                                    //                       .serviceName!)
                                    //           ? print(
                                    //               "This car item is add on the cart")
                                    //           : print(
                                    //               "The product not available on the cart section");
                                    //       // .then((v) => print(
                                    //       //     "${v} Thisi is the future tye of cart added on the addt cart item or not"));
                                    //       // print(
                                    //       //     "${} ");
                                    //       // Future.delayed(Duration.zero, () {
                                    //       //   addToCartController.addToCart();
                                    //       // });
                                    //       refresh();
                                    //     },
                                    //     child: Container(
                                    //       height: 40,
                                    //       width: 40,
                                    //       alignment: Alignment.center,
                                    //       decoration: BoxDecoration(
                                    //           color: primaryColor,
                                    //           borderRadius:
                                    //               BorderRadius.circular(
                                    //                   8.0)),
                                    //       child: Icon(
                                    //         Icons.add_shopping_cart_rounded,
                                    //         color: Colors.white,
                                    //         size: Theme.of(context)
                                    //             .textTheme
                                    //             .headlineLarge!
                                    //             .fontSize,
                                    //       ),
                                    //     ),
                                    //   ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              );
      },
    );
    //;
  }
}
