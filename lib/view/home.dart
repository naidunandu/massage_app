import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massage/controllers/home_controller.dart';
import 'package:massage/widgets/circle_object_widget.dart';
import 'package:massage/widgets/switcher_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (ctrl) {
        return Scaffold(
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
          body: Column(
            children: [
              const Text(
                "Tap on Body parts to\ncreate circle",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ).marginOnly(bottom: 25, top: 35),
              Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTapDown: (details) {
                          final offset = details.localPosition;
                          ctrl.onTapAddObject(offset);
                        },
                        child: Center(
                          child: Image.asset(
                            "assets/full_body.jpg",
                            width: ctrl.containerWidth,
                            height: ctrl.containerHeight,
                          ),
                        ),
                      ),
                      ...ctrl.circleObjects.map(
                        (object) {
                          return Positioned(
                            left: object.position.dx,
                            top: object.position.dy,
                            child: GestureDetector(
                              onLongPress: () => ctrl.onDeleteCircleObject(object),
                              // onPanUpdate: (details) => ctrl.onPositionChanged(object, details),
                              child: CircleObjectWidget(
                                color: object.color,
                                size: ctrl.circleSize,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ).marginOnly(bottom: 35),
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
        );
      },
    );
  }
}
