import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppPickerInput extends StatefulWidget {
  final String type;

  final TextEditingController controller;

  final String hintText;

  final IconData icon;

  const AppPickerInput({
    super.key,
    required this.type,
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  State<AppPickerInput> createState() => _AppPickerInputState();
}

class _AppPickerInputState extends State<AppPickerInput> {
  Future<void> pick() async {
    if (widget.type == "date") {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(4000),
      );

      if (picked != null) {
        widget.controller.text = DateFormat("dd-MM-yyyy").format(picked);
      }
    }

    if (widget.type == "time") {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null) {
        widget.controller.text = picked.format(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      onTap: pick,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icon),
      ),
    );
  }
}
