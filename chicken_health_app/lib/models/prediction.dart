class Prediction {
  final String prediction;
  final double confidence;
  final Map<String, double> probabilities;
  final String filename;
  final double? timestamp;

  Prediction({
    required this.prediction,
    required this.confidence,
    required this.probabilities,
    required this.filename,
    this.timestamp,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    // Konversi probabilities dari map ke map<string, double>
    Map<String, double> probs = {};
    if (json['probabilities'] != null) {
      json['probabilities'].forEach((key, value) {
        probs[key] = value.toDouble();
      });
    }

    return Prediction(
      prediction: json['prediction'] ?? '',
      confidence: json['confidence']?.toDouble() ?? 0.0,
      probabilities: probs,
      filename: json['filename'] ?? 'unknown',
      timestamp: json['timestamp']?.toDouble(),
    );
  }

  // Tambahkan method toJson untuk serialisasi
  Map<String, dynamic> toJson() {
    return {
      'prediction': prediction,
      'confidence': confidence,
      'probabilities': probabilities,
      'filename': filename,
      'timestamp': timestamp,
    };
  }

  // Helper untuk mendapatkan nama kondisi yang lebih user-friendly
  String get friendlyConditionName {
    switch (prediction) {
      case 'Chicken_Coccidiosis':
        return 'Koksidiosis';
      case 'Chicken_Healthy':
        return 'Sehat';
      case 'Chicken_NewCastleDisease':
        return 'Penyakit Newcastle';
      case 'Chicken_Salmonella':
        return 'Salmonella';
      default:
        return prediction;
    }
  }

  // Helper untuk mendapatkan deskripsi tentang kondisi
  String get conditionDescription {
    switch (prediction) {
      case 'Chicken_Coccidiosis':
        return 'Koksidiosis adalah penyakit parasit yang menyerang saluran pencernaan ayam, disebabkan oleh parasit protozoa dari genus Eimeria.';
      case 'Chicken_Healthy':
        return 'Ayam dalam kondisi sehat tanpa tanda-tanda penyakit yang terdeteksi.';
      case 'Chicken_NewCastleDisease':
        return 'Penyakit Newcastle adalah penyakit virus yang sangat menular yang menyerang sistem pernapasan, saraf, dan pencernaan ayam.';
      case 'Chicken_Salmonella':
        return 'Salmonella adalah infeksi bakteri yang dapat menyebar dari ayam ke manusia, menyebabkan keracunan makanan.';
      default:
        return 'Tidak ada deskripsi tersedia';
    }
  }
}