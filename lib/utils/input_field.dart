import 'package:apniseva/controller/dashboard_controller/dash_controller.dart';
import 'package:apniseva/model/dashboard_model/dash_model.dart';
import 'package:apniseva/screens/service/screens/service_screen.dart';
import 'package:apniseva/utils/api_strings/api_strings.dart';
import 'package:apniseva/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/subcategory_controller/subcategory_controller.dart';

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final searchController = Get.put(DashController());
  final subCategoryController = SubCategoryController();

  Future<Iterable<SearchDtl>> _suggestionCallBack(suggestion) async {
    if (suggestion.isEmpty) {
      return const Iterable<SearchDtl>.empty();
    }
    return searchController.dashDataModel.value.messages!.status!.searchDtl!
        .where((SearchDtl serviceName) =>
            serviceName.serviceName
                ?.toLowerCase()
                .toString()
                .contains(suggestion.toLowerCase()) ??
            false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TypeAheadFormField<SearchDtl>(
        suggestionsCallback: _suggestionCallBack,
        itemBuilder: (context, SearchDtl suggestion) {
          final search = suggestion;
          return ListTile(
            title: Text(search.serviceName!),
          );
        },
        onSuggestionSelected: (SearchDtl suggestion) async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString(ApiStrings.catID, suggestion.catId!);
          String? value = preferences.getString(ApiStrings.categoryID);
          debugPrint(value);
          // debugPrint(suggestion.serviceName);
          debugPrint(suggestion.catId);
          Get.to(() => const ServiceScreen());
        },
        noItemsFoundBuilder: (context) =>
            const Center(child: Text('No Service')),
        textFieldConfiguration: TextFieldConfiguration(
            style: Theme.of(context).textTheme.headlineMedium,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              hintText: 'AC repair, Washing Machine . . .',
              hintStyle: Theme.of(context).textTheme.titleMedium,
              prefixIcon: const Icon(Remix.search_2_line),
            )),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0))),
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  const TextInput({
    Key? key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.hintText = "hintText",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.labelLarge,
      cursorRadius: const Radius.circular(8),
      cursorColor: Colors.black,
      cursorWidth: 1.8,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.titleMedium,
        // prefixIcon: const Icon(Remix.search_2_line),
      ),
    );
  }
}

class PickerInputField extends StatefulWidget {
  final String pick;
  final double? width;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  const PickerInputField(
      {Key? key,
      required this.pick,
      this.controller,
      this.prefixIcon,
      this.width,
      this.hintText})
      : super(key: key);

  @override
  State<PickerInputField> createState() => _PickerInputFieldState();
}

class _PickerInputFieldState extends State<PickerInputField> {
  Future<void> reminderDate(String pick) async {
    if (pick == 'Date') {
      DateTime initialDate = DateTime.now();
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          lastDate: DateTime(4000),
          firstDate: initialDate);
      if (pickedDate != null) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        setState(() {
          widget.controller?.text =
              formattedDate; //set output date to TextField value.
        });
      } else {
        widget.controller!.text =
            DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
      }
    } else if (pick == 'Time') {
      TimeOfDay? initialTime = TimeOfDay.now();
      TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
          initialEntryMode: TimePickerEntryMode.dial);
      if (pickedTime != null) {
        setState(() {
          widget.controller!.text =
              pickedTime.format(context); //set output date to TextField value.
        });
      } else {
        widget.controller!.text = TimeOfDay.now().toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: TextFormField(
        onTap: () {
          reminderDate(widget.pick.toString());
        },
        controller: widget.controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: Theme.of(context).textTheme.headlineSmall,
        cursorColor: primaryColor,
        cursorWidth: 1.5,
        cursorHeight: 20,
        readOnly: true,
        cursorRadius: const Radius.circular(8),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter ${widget.hintText}';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 20,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
