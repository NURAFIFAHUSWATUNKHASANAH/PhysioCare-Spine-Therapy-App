import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pyhsiocare/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalDialog extends StatefulWidget {
  @override
  _JadwalDialogState createState() => _JadwalDialogState();
}

class _JadwalDialogState extends State<JadwalDialog> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _pesanController = TextEditingController();

  String? fcmToken;
  String? userId;

  @override
  void initState() {
    super.initState();
    _initFCMToken();
    _loadUserIdFromPrefs();
  }

  // --- LOGIKA ASLI TETAP DIPERTAHANKAN ---
  Future<void> _initFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() => fcmToken = token);
    } catch (e) {
      print('Gagal mendapatkan FCM token: $e');
    }
  }

  Future<void> _loadUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // final savedUserId = prefs.getString('_id');
    final savedUserId = prefs.getString('user_id');
    if (savedUserId != null) {
      setState(() => userId = savedUserId);
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(), // Modern: tidak bisa pilih tanggal lampau
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF0C2D57)),
        ),
        child: child!,
      ),
    );
    if (pickedDate != null) setState(() => selectedDate = pickedDate);
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF0C2D57)),
        ),
        child: child!,
      ),
    );
    if (pickedTime != null) setState(() => selectedTime = pickedTime);
  }

  Future<void> _submitJadwal() async {
    if (selectedDate == null || selectedTime == null) {
      Get.snackbar("Lengkapi Data", "Pilih tanggal dan waktu terlebih dahulu.",
          backgroundColor: Colors.orange.shade100, colorText: Colors.orange.shade900);
      return;
    }
    if (fcmToken == null || userId == null) {
      Get.snackbar("Sistem Sibuk", "Gagal memproses ID Pengguna, coba sesaat lagi.");
      return;
    }

    final tanggalFormatted = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final jamFormatted = selectedTime!.format(context);
    final pesan = _pesanController.text.isNotEmpty 
        ? _pesanController.text 
        : "Saatnya melakukan sesi fisioterapi mandiri!";

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.jadwalUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fcmToken": fcmToken,
          "user_id": userId,
          "tanggal": tanggalFormatted,
          "jam": jamFormatted,
          "pesan": pesan,
          "dikirim": false,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar("Berhasil", "Pengingat latihan telah dijadwalkan.",
            backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      } else {
        Get.snackbar("Gagal", "Kesalahan server: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal terhubung ke server.");
    }
  }

  // --- UI MODERN ---
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0C2D57);
    final tanggalText = selectedDate != null ? DateFormat('dd MMM yyyy').format(selectedDate!) : '';
    final waktuText = selectedTime != null ? selectedTime!.format(context) : '';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Set Pengingat",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primaryColor),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Tentukan kapan Anda ingin diingatkan untuk melakukan latihan rutin.",
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            
            // Input Tanggal
            _buildInputField(
              label: "Pilih Tanggal",
              controller: TextEditingController(text: tanggalText),
              icon: Icons.calendar_month_rounded,
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            
            // Input Waktu
            _buildInputField(
              label: "Atur Jam",
              controller: TextEditingController(text: waktuText),
              icon: Icons.access_time_filled_rounded,
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),
            
            // Input Pesan
            TextField(
              controller: _pesanController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Pesan Pengingat",
                labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                alignLabelWithHint: true,
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Contoh: Ayo latihan punggung!",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),
            
            // Tombol Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitJadwal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text("Simpan Jadwal", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      readOnly: true,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF0C2D57), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
    );
  }
}