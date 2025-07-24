import 'package:get/get.dart';

import '../controllers/level_select_controller.dart';

class LevelSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LevelSelectController>(
      () => LevelSelectController(),
    );
  }
}
