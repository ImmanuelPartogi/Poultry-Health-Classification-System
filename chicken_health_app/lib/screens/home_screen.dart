import 'package:chicken_health_app/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:chicken_health_app/services/api_service.dart';
import 'package:chicken_health_app/screens/result_screen.dart';
import 'package:chicken_health_app/screens/history_screen.dart'; // Tambahkan ini
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String _message = '';
  bool _isError = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
        _message = 'Memilih gambar...';
        _isError = false;
      });

      final XFile? photo = await _picker.pickImage(source: source);

      if (photo == null) {
        setState(() {
          _isLoading = false;
          _message = 'Pemilihan gambar dibatalkan';
        });
        return;
      }

      setState(() {
        _message = 'Mengirim gambar ke server...';
      });

      final result = await _apiService.predictImage(File(photo.path));
      final HistoryService historyService = HistoryService();
      await historyService.saveToHistory(photo.path, result);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _message = '';
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: photo.path,
            prediction: result,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _message = 'Error: ${e.toString()}';
        _isError = true;
      });
    }
  }

  Future<void> _testConnection() async {
    try {
      setState(() {
        _isLoading = true;
        _message = 'Menguji koneksi ke server...';
        _isError = false;
      });

      final result = await _apiService.testConnection();

      setState(() {
        _isLoading = false;
        _message = 'Koneksi berhasil: ${result['message']}';
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Koneksi gagal: ${e.toString()}';
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'Deteksi Kesehatan Ayam',
        //   style: GoogleFonts.poppins(
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat Deteksi',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo atau ilustrasi yang lebih minimalis
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Icon(
                    Icons.biotech,
                    size: 56,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                // Judul dengan font weight yang lebih ringan
                Text(
                  'Deteksi Kesehatan Ayam',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Deskripsi dengan warna yang lebih lembut
                Text(
                  'Unggah atau ambil gambar untuk menganalisis kesehatan ayam',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                // Message dengan desain yang lebih clean
                if (_message.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isError
                          ? const Color(0xFFFFF0F0)
                          : const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isError
                            ? const Color(0xFFFFCCCC)
                            : const Color(0xFFDCEEFF),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isError
                              ? Icons.info_outline
                              : Icons.check_circle_outline,
                          color: _isError
                              ? const Color(0xFFE53935)
                              : const Color(0xFF2E7D32),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _message,
                            style: GoogleFonts.poppins(
                              color: _isError
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFF2E7D32),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Loading dan tombol dengan layout yang lebih clean
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading)
                        Column(
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primaryColor),
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _message,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            // Tombol dengan desain yang lebih minimalis
                            _buildActionButton(
                              icon: Icons.camera_alt_rounded,
                              label: 'Ambil Foto',
                              onPressed: () =>
                                  _processImage(ImageSource.camera),
                            ),
                            const SizedBox(height: 16),
                            // Tombol galeri
                            _buildActionButton(
                              icon: Icons.photo_library_rounded,
                              label: 'Pilih dari Galeri',
                              isOutlined: true,
                              onPressed: () =>
                                  _processImage(ImageSource.gallery),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // // Tombol test koneksi dengan desain yang sederhana
                // TextButton.icon(
                //   onPressed: _testConnection,
                //   icon: Icon(
                //     Icons.wifi_tethering,
                //     size: 16,
                //     color: primaryColor,
                //   ),
                //   label: Text(
                //     'Test Koneksi API',
                //     style: GoogleFonts.poppins(
                //       fontSize: 13,
                //       color: primaryColor,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isOutlined = false,
    required VoidCallback onPressed,
  }) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Container(
      width: double.infinity,
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isOutlined ? Colors.white : primaryColor,
          foregroundColor: isOutlined ? primaryColor : Colors.white,
          side: isOutlined ? BorderSide(color: primaryColor) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
