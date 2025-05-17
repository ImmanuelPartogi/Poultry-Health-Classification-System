import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chicken_health_app/models/prediction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:chicken_health_app/services/history_service.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final Prediction prediction;
  final bool fromHistory;

  const ResultScreen({
    Key? key,
    required this.imagePath,
    required this.prediction,
    this.fromHistory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Warna yang lebih soft dan profesional
    final Color statusColor;
    final IconData statusIcon;

    switch (prediction.prediction) {
      case 'Chicken_Healthy':
        statusColor = const Color(0xFF66BB6A);
        statusIcon = Icons.health_and_safety;
        break;
      case 'Chicken_Coccidiosis':
        statusColor = const Color(0xFFEF5350);
        statusIcon = Icons.coronavirus;
        break;
      case 'Chicken_NewCastleDisease':
        statusColor = const Color(0xFFFFA726);
        statusIcon = Icons.sick;
        break;
      case 'Chicken_Salmonella':
        statusColor = const Color(0xFFAB47BC);
        statusIcon = Icons.bug_report;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hasil Diagnosis',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar dengan overlay yang lebih sederhana
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            prediction.friendlyConditionName,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content dengan desain yang lebih clean
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Confidence badge
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        color: statusColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tingkat Keyakinan:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '${(prediction.confidence * 100).toStringAsFixed(2)}%',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Deskripsi dengan card yang lebih minimalis
                  Text(
                    'Deskripsi Kondisi',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      prediction.conditionDescription,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Probabilitas
                  Text(
                    'Probabilitas Semua Kondisi',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Probabilitas dalam bentuk cards yang lebih minimalis
                  ...prediction.probabilities.entries.map((entry) {
                    String kondisi = entry.key.replaceAll('Chicken_', '');
                    bool isSelected = entry.key == prediction.prediction;

                    // Warna untuk setiap kondisi yang lebih lembut
                    Color conditionColor;
                    switch (entry.key) {
                      case 'Chicken_Healthy':
                        conditionColor = const Color(0xFF66BB6A);
                        break;
                      case 'Chicken_Coccidiosis':
                        conditionColor = const Color(0xFFEF5350);
                        break;
                      case 'Chicken_NewCastleDisease':
                        conditionColor = const Color(0xFFFFA726);
                        break;
                      case 'Chicken_Salmonella':
                        conditionColor = const Color(0xFFAB47BC);
                        break;
                      default:
                        conditionColor = Colors.grey;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? conditionColor.withOpacity(0.5)
                              : Colors.grey[200]!,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: conditionColor,
                                    size: 16,
                                  ),
                                ),
                              Text(
                                kondisi,
                                style: GoogleFonts.poppins(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${(entry.value * 100).toStringAsFixed(1)}%',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: conditionColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress bar yang lebih slim
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: entry.value,
                              backgroundColor: Colors.grey[100],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(conditionColor),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Tombol kembali yang lebih minimalis
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Kembali',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '$title:',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
