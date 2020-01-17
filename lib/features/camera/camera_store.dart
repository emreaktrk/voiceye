import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Im;

part 'camera_store.g.dart';

class CameraStore = _CameraStore with _$CameraStore;

abstract class _CameraStore with Store {
  CameraController controller;

  @action
  void takePicture(BuildContext context) {
    getApplicationDocumentsDirectory().then((directory) {
      var file = File('${directory.path}/temp.jpg');
      if (file.existsSync()) {
        file.deleteSync();
      }

      controller.takePicture(file.path).then((_) {
        rootBundle.load(file.path).then((_) {
          compress(file).then((compressed) {

          });
        });
      });
    });
  }

  @action
  Future<File> compress(File file) => getTemporaryDirectory().then((directory) {
        Im.Image original = Im.decodeImage(file.readAsBytesSync());
        Im.Image smaller = Im.copyResize(original, width: 1080, height: 1080);

        File compressed = new File('${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
        compressed.writeAsBytesSync(Im.encodeJpg(smaller, quality: 100));

        return Future<File>.value(compressed);
      }).catchError((error) {
        return Future<File>.error(null);
      });
}
