import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const PrimaryAppBar({Key? key, this.title = 'Title'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Remix.arrow_left_s_line,
                color: Colors.white,
              )),
          titleSpacing: 10,
          title: Text(title!),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
