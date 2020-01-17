import 'package:voiceye/data/model/bounding_box.dart';

class Predictions {
  static const THRESHOLD = 0.7;

  final double probability;
  final String tagId;
  final String tagName;
  final BoundingBox boundingBox;

  Predictions.fromJsonMap(Map<String, dynamic> map)
      : probability = map["probability"],
        tagId = map["tagId"],
        tagName = map["tagName"],
        boundingBox = BoundingBox.fromJsonMap(map["boundingBox"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['probability'] = probability;
    data['tagId'] = tagId;
    data['tagName'] = tagName;
    data['boundingBox'] = boundingBox == null ? null : boundingBox.toJson();
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
