import 'package:voiceye/data/model/predictions.dart';

class Vision {

  final String id;
  final String project;
  final String iteration;
  final String created;
  final List<Predictions> predictions;

	Vision.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		project = map["project"],
		iteration = map["iteration"],
		created = map["created"],
		predictions = List<Predictions>.from(map["predictions"].map((it) => Predictions.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['project'] = project;
		data['iteration'] = iteration;
		data['created'] = created;
		data['predictions'] = predictions != null ? 
			this.predictions.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
