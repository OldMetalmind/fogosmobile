import 'dart:convert';

import 'package:fogosmobile/models/base_location_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

LightningRemote lightningFromJson(String str) =>
    LightningRemote.fromJson(json.decode(str));

String lightningToJson(LightningRemote data) => json.encode(data.toJson());

class LightningRemote {
  LightningRemote({
    required this.data,
  });

  List<Lightning> data;

  factory LightningRemote.fromJson(Map<String, dynamic> json) =>
      LightningRemote(
        data: List<Lightning>.from(
          json["data"].map((x) => Lightning.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  static List<LightningRemote> fromList(List<dynamic> obj) {
    return obj
        .cast<Map<String, dynamic>>()
        .map((data) => LightningRemote.fromJson(data))
        .toList();
  }
}

class Lightning extends BaseMapboxModel {
  Lightning({
    required this.timestamp,
    required this.payload,
  }) : super(LatLng(payload.latitude, payload.longitude), timestamp);

  String timestamp;
  LightningData payload;

  factory Lightning.fromJson(Map<String, dynamic> json) => Lightning(
        timestamp: json["timestamp"],
        payload: LightningData.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "payload": payload.toJson(),
      };

  @override
  bool skip<T>(List<T> filter) {
    //TODO: confirm if this is the correct way to filter
    return false;
  }
}

class LightningData {
  LightningData({
    required this.latitude,
    required this.amplitude,
    required this.longitude,
  });

  double latitude;
  double amplitude;
  double longitude;

  factory LightningData.fromJson(Map<String, dynamic> json) => LightningData(
        latitude: json["latitude"].toDouble(),
        amplitude: json["amplitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "amplitude": amplitude,
        "longitude": longitude,
      };
}
