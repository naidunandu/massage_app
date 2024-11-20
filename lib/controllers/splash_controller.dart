import 'package:get/get.dart';
import 'package:massage/routes/route_name.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed(RouteNames.home);
    });
    super.onInit();
  }
}
