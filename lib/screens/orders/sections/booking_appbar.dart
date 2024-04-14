import 'package:flutter/material.dart';

class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const OrdersAppBar({Key? key,
    this.title = 'Title',
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
       automaticallyImplyLeading: false,
        title: Text(title),
      ),
    );
  }


}
