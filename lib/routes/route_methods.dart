import 'package:get/get.dart';
import 'package:massage/routes/route_name.dart';

import '../view/splash.dart';
import '../view/home.dart';

class AppRoutes {
  static GetPage<dynamic> getPage({
    required String name,
    required GetPageBuilder page,
    List<GetMiddleware>? middlewares,
  }) {
    return GetPage(
      name: name,
      page: page,
      transition: Transition.topLevel,
      showCupertinoParallax: true,
      middlewares: middlewares ?? [],
      transitionDuration: 350.milliseconds,
    );
  }

  static List<GetPage> pages = [
    getPage(name: RouteNames.splash, page: () => const SplashView()),
    getPage(name: RouteNames.home, page: () => const HomeView()),
  ];
}
