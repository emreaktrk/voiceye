import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:screentheme/screentheme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:voiceye/features/upload/upload_page.dart';

class CameraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CameraState();
  }
}

class CameraState extends State<CameraPage> {
  CameraController controller;

  @override
  void initState() {
    super.initState();

    ScreenTheme.updateNavigationBarColor(Colors.black);
    ScreenTheme.lightStatusBar();
    ScreenTheme.lightNavigationBar();

    availableCameras().then((cameras) {
      controller = CameraController(cameras[0], ResolutionPreset.low);

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Scaffold(backgroundColor: Colors.black);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          Expanded(
            child: new CameraButton(controller: controller),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class CameraButton extends StatelessWidget {
  const CameraButton({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () => takePicture(context, controller),
        child: Icon(Icons.camera, color: Colors.white),
      ),
    );
  }
}

void takePicture(BuildContext context, CameraController controller) {
  clear().then((path) {
    controller.takePicture(path).then((_) {
      var file = File(path);
      compress(file).then((compressed) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => UploadPage.withFile(file: compressed),
            ),
            (Route<dynamic> route) => false);
      });
    });
  });
}

Future<File> compress(File file) => getTemporaryDirectory().then((directory) {
      Im.Image original = Im.decodeImage(file.readAsBytesSync());
      Im.Image smaller = Im.copyResize(original, width: 1080, height: 1080);

      File compressed = new File(
          '${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      compressed.writeAsBytesSync(Im.encodeJpg(smaller, quality: 100));

      return Future<File>.value(compressed);
    }).catchError((error) {
      return Future<File>.error(null);
    });

Future<String> clear() async {
  var directory = await getApplicationDocumentsDirectory();
  var path = '${directory.path}/temp.jpg';
  var file = File(path);
  var isExist = await file.exists();
  if (isExist) {
    await file.delete();
  }

  return path;
}
