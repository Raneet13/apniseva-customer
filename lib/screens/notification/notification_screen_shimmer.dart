import 'package:flutter/material.dart';

Widget notificationShimmer() {
  return ListView.separated(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          // color:
          //     ndex != null && ndex == index ? Colors.green : null,
          margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)]),
          child: ListTile(
            leading: Icon(Icons.image),
            tileColor: Colors.white,
            hoverColor: Colors.yellow,
            splashColor: Colors.yellow,
            onTap: () {
              // context.push('/home/bookingsr1',
              //     extra: {'id': "0"});
            },
            title: Text(
              "Notification ${index}",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            subtitle: FittedBox(
              child: Text(
                "Bus Sta Upas, maestic, Bengaluru, Karnataka, 560989...",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
            height: 5,
          ));
}
