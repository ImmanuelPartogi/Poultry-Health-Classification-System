import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:chicken_health_app/models/history_entry.dart';
import 'package:chicken_health_app/models/prediction.dart';

class HistoryService {
  static const String _historyKey = 'chicken_health_history';
  static final Uuid _uuid = Uuid();
  
  // Menyimpan hasil analisis ke history
  Future<HistoryEntry> saveToHistory(String imagePath, Prediction prediction) async {
    try {
      // Simpan salinan gambar di direktori aplikasi
      final savedImagePath = await _saveImageCopy(imagePath);
      
      // Buat entri history baru
      final entry = HistoryEntry(
        id: _uuid.v4(),
        imagePath: savedImagePath,
        prediction: prediction,
        timestamp: DateTime.now(),
      );
      
      // Dapatkan history yang ada
      final prefs = await SharedPreferences.getInstance();
      final List<HistoryEntry> history = await getHistory();
      
      // Tambahkan entri baru dan simpan
      history.insert(0, entry); // Tambahkan ke awal list (entri terbaru)
      await prefs.setString(_historyKey, HistoryEntry.encode(history));
      
      return entry;
    } catch (e) {
      print('Error saving to history: $e');
      rethrow;
    }
  }
  
  // Mendapatkan semua history
  Future<List<HistoryEntry>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyString = prefs.getString(_historyKey);
      
      if (historyString == null || historyString.isEmpty) {
        return [];
      }
      
      return HistoryEntry.decode(historyString);
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }
  
  // Menghapus item dari history
  Future<bool> deleteHistoryItem(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<HistoryEntry> history = await getHistory();
      
      // Temukan dan hapus item
      final entryToDelete = history.firstWhere((entry) => entry.id == id);
      history.removeWhere((entry) => entry.id == id);
      
      // Hapus gambar yang tersimpan
      final imageFile = File(entryToDelete.imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      
      // Simpan history yang telah diperbarui
      await prefs.setString(_historyKey, HistoryEntry.encode(history));
      return true;
    } catch (e) {
      print('Error deleting history item: $e');
      return false;
    }
  }
  
  // Menghapus semua history
  Future<bool> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<HistoryEntry> history = await getHistory();
      
      // Hapus semua gambar tersimpan
      for (var entry in history) {
        final imageFile = File(entry.imagePath);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }
      
      // Hapus data history
      await prefs.remove(_historyKey);
      return true;
    } catch (e) {
      print('Error clearing history: $e');
      return false;
    }
  }
  
  // Menyimpan salinan gambar di direktori aplikasi
  Future<String> _saveImageCopy(String originalPath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final historyDir = Directory('${directory.path}/history_images');
      
      // Buat direktori jika belum ada
      if (!await historyDir.exists()) {
        await historyDir.create(recursive: true);
      }
      
      // Buat nama file unik
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${historyDir.path}/$fileName';
      
      // Salin file
      await File(originalPath).copy(newPath);
      return newPath;
    } catch (e) {
      print('Error saving image copy: $e');
      return originalPath; // Kembalikan path asli jika gagal
    }
  }
}