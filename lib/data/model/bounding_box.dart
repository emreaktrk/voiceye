
class BoundingBox {

  final double left;
  final double top;
  final double width;
  final double height;

	BoundingBox.fromJsonMap(Map<String, dynamic> map): 
		left = map["left"],
		top = map["top"],
		width = map["width"],
		height = map["height"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['left'] = left;
		data['top'] = top;
		data['width'] = width;
		data['height'] = height;
		return data;
	}
}
