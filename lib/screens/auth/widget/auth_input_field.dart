import 'package:flutter/material.dart';

import 'auth_strings.dart';


class PhoneNumberVerification extends StatefulWidget {
  final TextEditingController controller;
  final validator;
  const PhoneNumberVerification(
      {Key? key,
        this.validator,
        required this.controller
      }) : super(key: key);

  @override
  State<PhoneNumberVerification> createState() => _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 8.0),
            margin: const EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.shade500
                ),
                borderRadius: BorderRadius.circular(8.0)
            ),
            child: Text('+91-',
              style: Theme.of(context).inputDecorationTheme.labelStyle,
            )
        ),
        Expanded(
          child: TextFormField(
            style: Theme.of(context).textTheme.labelLarge,
            validator: widget.validator,
            controller: widget.controller,
            cursorColor: Colors.black,
            cursorRadius: const Radius.circular(10),
            cursorWidth: 1.5,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            maxLength: 10,
            decoration: InputDecoration(
              counterText: '',
              hintText: AuthString.inputHint,
            ),
          ),
        ),
      ],
    );
  }
}
