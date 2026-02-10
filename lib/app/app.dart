import 'package:apniseva/app/theme/app_theme.dart' as AppTheme;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'routes/route_names.dart';
import 'theme/app_theme.dart';
import 'bindings/initial_binding.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'APNI SEVA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: RouteNames.splash,
      getPages: AppPages.pages,
      initialBinding: InitialBinding(),
    );
  }
}
