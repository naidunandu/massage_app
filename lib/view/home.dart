import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massage/controllers/home_controller.dart';
import 'package:massage/widgets/circle_object_widget.dart';
import 'package:massage/widgets/switcher_widget.dart';
import 'dart:ui' as ui;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (ctrl) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Massage App"),
              actions: [
                IconButton(
                  onPressed: () => ctrl.onUndoEvent(),
                  icon: const Icon(Icons.undo),
                ),
                IconButton(
                  onPressed: () => ctrl.onSaveEvent(),
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Tap on Body parts to\ncreate circle",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ).marginOnly(top: 35),
                  Column(
                    children: [
                      FutureBuilder(
                        future: ctrl.loadImages(),
                        builder: (context, snapshot) {
                          if (ctrl.baseImage != null) {
                            final screenSize = MediaQuery.of(context).size;
                            final imageWidth = ctrl.baseImage!.width.toDouble();
                            final imageHeight = ctrl.baseImage!.height.toDouble();

                            // Calculate uniform scale factor to fit within screen width
                            final scale = (screenSize.width / imageWidth).clamp(0.0, 1.0);
                            final scaledWidth = imageWidth * scale;
                            final scaledHeight = imageHeight * scale;

                            return Stack(
                              children: [
                                GestureDetector(
                                  onTapDown: (details) async {
                                    final offset = details.localPosition / scale;
                                    if (await ctrl.isTransparentAtOffset(offset)) {
                                      ctrl.onTapAddObject(offset);
                                    }
                                  },
                                  child: CustomPaint(
                                    size: Size(scaledWidth, scaledHeight),
                                    painter: MyImagePainter(ctrl.baseImage!, scale),
                                  ),
                                ),
                                ...ctrl.circleObjects.map(
                                  (object) {
                                    return Positioned(
                                      left: object.position.dx * scale,
                                      top: object.position.dy * scale,
                                      child: GestureDetector(
                                        onLongPress: () => ctrl.onDeleteCircleObject(object),
                                        child: CircleObjectWidget(
                                          color: object.color,
                                          size: ctrl.circleSize * scale,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ).marginOnly(bottom: 35);
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      const Text(
                        "Select Color",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ).marginOnly(bottom: 5),
                      SwitcherWidget(
                        selectedColor: ctrl.selectedColor,
                        onTabSelect: (color) => ctrl.onTabSelectColor(color),
                        colors: ctrl.availableColors,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyImagePainter extends CustomPainter {
  final ui.Image image;
  final double scale;

  MyImagePainter(this.image, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the scaled size
    final scaledWidth = image.width * scale;
    final scaledHeight = image.height * scale;

    // Define the source rectangle (original image dimensions)
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());

    // Define the destination rectangle (scaled dimensions)
    final dstRect = Rect.fromLTWH(0, 0, scaledWidth, scaledHeight);

    // Draw the scaled image
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint if the image or scale hasn't changed
  }
}
