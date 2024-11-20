import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massage/controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (ctrl) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fitbit_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ).marginOnly(bottom: 10),
                const Text(
                  "Massage App",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
