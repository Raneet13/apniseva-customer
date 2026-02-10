import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../controller/dash_controller.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../service/presentation/views/service_screen.dart';

class SearchField extends GetView<DashController> {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            hintText: "Search service...",
          ),
        );
      },
      suggestionsCallback: (pattern) {
        if (pattern.isEmpty) return [];

        return controller.searchList
            .where((e) => e.serviceName!.toLowerCase().contains(
                  pattern.toLowerCase(),
                ))
            .toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.serviceName),
        );
      },
      onSelected: (suggestion) async {
        final storage = Get.find<StorageService>();

        await storage.setCatId(suggestion.catId);

        Get.to(() => const ServiceScreen());
      },
    );
  }
}
