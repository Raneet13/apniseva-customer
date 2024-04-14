import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;
  final Widget child;
  const PrimaryButton({Key? key, required this.width, required this.height, this.borderRadius = 8, required this.onPressed, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
          )
          // backgroundColor:
        ),
          child: child

        /*Text(label,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600
        ),
      ),*/
      ),
    );
  }
}


class SecoundaryButton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;
  final Widget child;
  const SecoundaryButton({Key? key, required this.width, required this.height, this.borderRadius = 8, required this.onPressed, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          fixedSize: Size(width, height),
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black,
                  width: 1.2
                ),
                borderRadius: BorderRadius.circular(borderRadius)
            )
        ),
        child: child
    );
  }
}