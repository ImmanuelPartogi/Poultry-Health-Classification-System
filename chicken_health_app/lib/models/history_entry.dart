import 'dart:convert';
import 'package:chicken_health_app/models/prediction.dart';

class HistoryEntry {
  final String id;
  final String imagePath;
  final Prediction prediction;
  final DateTime timestamp;

  HistoryEntry({
    required this.id,
    required this.imagePath,
    required this.prediction,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'prediction': prediction.toJson(),
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'],
      imagePath: json['imagePath'],
      prediction: Prediction.fromJson(json['prediction']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }

  static String encode(List<HistoryEntry> history) {
    return json.encode(
      history.map<Map<String, dynamic>>((entry) => entry.toJson()).toList(),
    );
  }

  static List<HistoryEntry> decode(String history) {
    return (json.decode(history) as List<dynamic>)
        .map<HistoryEntry>((item) => HistoryEntry.fromJson(item))
        .toList();
  }
}