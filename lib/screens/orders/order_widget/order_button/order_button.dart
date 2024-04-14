import 'package:apniseva/screens/orders/order_widget/order_strings.dart';
import 'package:flutter/material.dart';


class AcceptOrderButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AcceptOrderButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.bottom + MediaQuery.of(context).padding.top);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 25,
        width: 65,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5.0)
        ),

        child: Text(OrderButtonString.orderAccept,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}


class RejectOrderButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const RejectOrderButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 25,
        width: 65,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5.0)
        ),

        child: Text(OrderButtonString.orderReject,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              color: Colors.white
          ),
        ),
      ),
    );
  }
}
