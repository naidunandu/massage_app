import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:massage/models/position.dart';
import 'package:massage/utils/toast.dart';

import '../utils/constants.dart';
import '../utils/storage.dart';
import 'dart:ui' as ui;

class HomeController extends GetxController {
  @override
  void onInit() {
    loadImages();
    super.onInit();
  }

  List<PositionedModel> circleObjects = [];
  double circleSize = 30;
  String selectedColor = "Green";
  List<String> availableColors = ["Green", "Red"];

  ui.Image? baseImage;
  ui.Image? maskImage;

  //Load Both Images
  Future<void> loadImages() async {
    ui.Image base = await _loadImage('assets/full_body.png');
    ui.Image mask = await _loadImage('assets/mask.png');

    // Resize mask to match base dimensions
    if (base.width != mask.width || base.height != mask.height) {
      mask = await _resizeImage(mask, base.width, base.height);
    }

    baseImage = base;
    maskImage = mask;
    onLoadEvent();
    update();
  }

  Future<ui.Image> _resizeImage(ui.Image image, int targetWidth, int targetHeight) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint();

    // Scale and draw the image onto a new canvas
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      paint,
    );

    final picture = pictureRecorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<bool> isTransparentAtOffset(Offset offset) async {
    ByteData? maskData = await maskImage!.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (maskData == null) return false;
    int pixelIndex = (offset.dy.toInt() * maskImage!.width + offset.dx.toInt()) * 4;
    int alpha = maskData.getUint8(pixelIndex + 3);
    return alpha == 0;
  }

  onTapAddObject(Offset offset) {
    final adjustedPosition = Offset(offset.dx - circleSize / 2, offset.dy - circleSize / 2);
    final id = (circleObjects.length + 1).toString();

    circleObjects.add(
      PositionedModel(id: id, color: selectedColor, position: adjustedPosition),
    );
    update();
  }

  onDeleteCircleObject(PositionedModel object) {
    Get.defaultDialog(
      title: "Delete Object",
      middleText: "Do you really want to delete?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        circleObjects.remove(object);
        update();
        Get.back();
      },
      onCancel: () => Get.back(),
      buttonColor: Colors.red,
    );
  }

  onTabSelectColor(String color) {
    selectedColor = color;
    update();
  }

  onUndoEvent() {
    if (circleObjects.isNotEmpty) {
      circleObjects.removeLast();
      update();
    } else {
      warningToast("There is no history!");
    }
  }

  onSaveEvent() {
    List<Map<String, dynamic>> currentData = circleObjects.map((obj) => obj.toMap()).toList();
    writeStorage(Constants.circleObjectKey, currentData);
    successToast("Your selections are saved successfully!");
  }

  onLoadEvent() {
    List? localCircleObjects = getStorage(Constants.circleObjectKey);
    if (localCircleObjects != null) {
      circleObjects = localCircleObjects.map((e) => PositionedModel.fromMap(e)).toList();
      update();
    }
  }
}
