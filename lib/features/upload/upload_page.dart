import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:screentheme/screentheme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voiceye/data/model/predictions.dart';
import 'package:voiceye/data/model/vision.dart';

class UploadPage extends StatefulWidget {
  final File file;

  UploadPage.withFile({this.file}) {
    ScreenTheme.updateNavigationBarColor(Colors.cyan);
    ScreenTheme.lightStatusBar();
    ScreenTheme.lightNavigationBar();
  }

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String content = "Loading..";

  @override
  Widget build(BuildContext context) {
    stream(widget.file).then((vision) {
      setState(() {
        final buffer = StringBuffer();

        vision.predictions.forEach((prediction) {
          if (prediction.probability > Predictions.THRESHOLD) {
            buffer.write(prediction);
            buffer.write("\n\n");
          }
        });
        content = buffer.toString();

        if (content.isEmpty) {
          content = "No Predictions have more than 0.7 probability.";
        }
      });
    });

    return Scaffold(
      backgroundColor: Colors.cyan,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Vision> stream(File file) async {
    final client = new http.Client();
    final request = new http.Request(
      "POST",
      Uri.parse(
        "https://westeurope.api.cognitive.microsoft.com/customvision/v3.0/Prediction/af940af5-bb6b-487d-804f-4cd2ecd828ff/detect/iterations/Iteration2/image?Prediction-Key=e32333340c2c437392ec1a22d4d06c37&Content-Type=application/octet-stream",
      ),
    );
    request.headers.addAll({
      "Prediction-Key": "e32333340c2c437392ec1a22d4d06c37",
      "Content-Type": "application/octet-stream"
    });
    request.bodyBytes = file.readAsBytesSync();
    final response = await client.send(request);
    final raw = await response.stream.bytesToString();
    final data = jsonDecode(raw);
    final vision = Vision.fromJsonMap(data);
    return Future<Vision>.value(vision);
  }
}
