import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class AddressAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const AddressAppBar(
      {Key? key,
        this.title = 'Title',
      }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Remix.arrow_drop_left_line,
              size: Theme.of(context).iconTheme.size,
            ),
          ),
          title: Text(title),
        )
    );
  }
}
