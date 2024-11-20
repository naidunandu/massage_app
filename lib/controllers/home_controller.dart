import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massage/models/position.dart';
import 'package:massage/utils/toast.dart';

import '../utils/constants.dart';
import '../utils/storage.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    onLoadEvent();
    super.onInit();
  }

  List<PositionedModel> circleObjects = [];
  double containerHeight = 400;
  double containerWidth = 280;
  double circleSize = 40;
  String selectedColor = "Green";
  List<String> availableColors = ["Green", "Red"];

  //Load Data From Get Storage to Circle Objects
  onLoadEvent() {
    List? localCircleObjects = getStorage(Constants.circleObjectKey);
    if (localCircleObjects != null) {
      circleObjects = localCircleObjects.map((e) => PositionedModel.fromMap(e)).toList();
      update();
    }
  }

  //Add New Circle Object
  onTapAddObject(Offset offset) {
    if (circleObjects.isNotEmpty) {
      int id = int.parse(circleObjects[circleObjects.length - 1].id) + 1;
      PositionedModel object = PositionedModel(
        id: id.toString(),
        color: selectedColor,
        position: Offset(offset.dx - circleSize / 2, offset.dy - circleSize / 2),
      );
      circleObjects.add(object);
      update();
    } else {
      PositionedModel object = PositionedModel(
        id: "1",
        color: selectedColor,
        position: Offset(offset.dx - circleSize / 2, offset.dy - circleSize / 2),
      );
      circleObjects.add(object);
      update();
    }
  }

  //On Long Press Delete Object
  onDeleteCircleObject(PositionedModel object) {
    Get.defaultDialog(
      title: "Delete Object",
      middleText: "Do you really want to delete?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        int index = circleObjects.indexWhere((e) => e.id == object.id).toInt();
        if (index != -1) {
          circleObjects.removeAt(index);
          update();
        }
        Get.back();
      },
      onCancel: () {
        Get.back(); // Close the dialog
      },
      buttonColor: Colors.red,
    );
  }

  //On Draging Circle Object
  onPositionChanged(PositionedModel object, DragUpdateDetails details) {
    double newLeft = object.position.dx + details.delta.dx;
    double newTop = object.position.dy + details.delta.dy;

    //Identifing Boundry
    double minLeft = 0;
    double minTop = 0;
    double maxLeft = containerWidth - circleSize;
    double maxTop = containerHeight - circleSize;

    //Find Index Of Object and Apply Position
    int index = circleObjects.indexWhere((e) => e.id == object.id).toInt();
    if (index != -1) {
      if (newLeft >= minLeft && newLeft <= maxLeft) {
        circleObjects[index].position = Offset(newLeft, object.position.dy);
      }
      if (newTop >= minTop && newTop <= maxTop) {
        circleObjects[index].position = Offset(object.position.dx, newTop);
      }
      update();
    }
  }

  //Bottom Tab Color Selector
  onTabSelectColor(String color) {
    selectedColor = color;
    update();
  }

  //Undo Event :: Remove Object From Circle Objects From Last
  onUndoEvent() {
    if (circleObjects.isEmpty) {
      warningToast("There is no history!");
    } else {
      circleObjects.removeLast();
      update();
    }
  }

  //Save Data to Get Storage
  onSaveEvent() {
    List<Map<String, dynamic>> currentData = circleObjects.map((obj) => obj.toMap()).toList();
    writeStorage(Constants.circleObjectKey, currentData);
    successToast("You selections are saved successfully!");
  }
}
