import 'package:get/get.dart';

import '../controllers/food_cart_controller.dart';

class FoodCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodCartController>(
      () => FoodCartController(),
    );
  }
}