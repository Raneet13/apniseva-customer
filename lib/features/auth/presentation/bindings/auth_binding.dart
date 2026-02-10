import 'package:get/get.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../controller/auth_controller.dart';

import '../../../../core/storage/storage_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRemoteDataSource());

    Get.lazyPut(() => AuthRepository(Get.find()));

    Get.lazyPut(
      () => AuthController(
        Get.find(),
        Get.find<StorageService>(),
      ),
    );
  }
}
