import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chicken_health_app/models/prediction.dart';
import 'package:path/path.dart' as path;

class ApiService {
  // Gunakan IP komputer Anda di jaringan yang sama dengan ponsel
  static const String baseUrl = 'http://192.168.50.145:8000'; // Sesuaikan IP ini

  Future<Prediction> predictImage(File imageFile) async {
    try {
      print("Mengirim file: ${imageFile.path}");
      
      // Dapatkan nama file dari path
      final fileName = path.basename(imageFile.path);
      
      // Buat request
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
      
      // Tambahkan header
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      });
      
      // Tambahkan file ke request dengan nama field "file"
      var multipartFile = await http.MultipartFile.fromPath(
        'file',  // Nama field HARUS SAMA dengan parameter di FastAPI
        imageFile.path,
        filename: fileName,
      );
      request.files.add(multipartFile);
      
      print("Request dipersiapkan, mengirim ke server...");
      
      // Kirim request
      var streamedResponse = await request.send();
      print("Response status code: ${streamedResponse.statusCode}");
      
      // Parse response
      var response = await http.Response.fromStream(streamedResponse);
      print("Response body: ${response.body}");
      
      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
      
      // Parse response JSON
      var jsonData = jsonDecode(response.body);
      return Prediction.fromJson(jsonData);
      
    } catch (e) {
      print("Error saat prediksi gambar: $e");
      rethrow;
    }
  }
  
  // Metode untuk tes koneksi API
  Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to connect to API: ${response.statusCode}');
      }
    } catch (e) {
      print("Error saat tes koneksi: $e");
      rethrow;
    }
  }
}