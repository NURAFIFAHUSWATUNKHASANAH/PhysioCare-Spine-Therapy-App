import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Untuk format Indonesia
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pyhsiocare/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalDialog extends StatefulWidget {
  const JadwalDialog({super.key});

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
    initializeDateFormatting('id_ID', null); // Inisialisasi format Indo
    _initFCMToken();
    _loadUserIdFromPrefs();
  }

  // --- LOGIKA ASLI TETAP DIPERTAHANKAN ---
  Future<void> _initFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() => fcmToken = token);
    } catch (e) {
      debugPrint('Gagal mendapatkan FCM token: $e');
    }
  }

  Future<void> _loadUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('user_id');
    if (savedUserId != null) {
      setState(() => userId = savedUserId);
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0C2D57),
            onPrimary: Colors.white,
            onSurface: Color(0xFF0C2D57),
          ),
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
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0C2D57),
            onSurface: Color(0xFF0C2D57),
          ),
        ),
        child: child!,
      ),
    );
    if (pickedTime != null) setState(() => selectedTime = pickedTime);
  }

  Future<void> _submitJadwal() async {
    if (selectedDate == null || selectedTime == null) {
      Get.snackbar(
        "Lengkapi Data", 
        "Pilih tanggal dan waktu terlebih dahulu.",
        backgroundColor: Colors.white,
        colorText: const Color(0xFF0C2D57),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (fcmToken == null || userId == null) {
      Get.snackbar("Sistem Sibuk", "Gagal memproses data pengguna.");
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
            backgroundColor: Colors.green.shade600, colorText: Colors.white);
      } else {
        Get.snackbar("Gagal", "Kesalahan server: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal terhubung ke server.");
    }
  }

  // --- UI MODERN & STABIL ---
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0C2D57);
    const Color bgInput = Color(0xFFF8FAFC);
    
    final tanggalDisplay = selectedDate != null 
        ? DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate!) 
        : 'Pilih Tanggal';
    final waktuDisplay = selectedTime != null ? selectedTime!.format(context) : 'Atur Jam';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        // Fix: Material widget sebagai pembungkus utama konten dalam Dialog
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_active_rounded, color: primaryColor, size: 28),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Set Pengingat",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildLabel("Kapan Anda akan berlatih?"),
                  _buildActionTile(
                    text: tanggalDisplay,
                    icon: Icons.calendar_today_rounded,
                    isSelected: selectedDate != null,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    text: waktuDisplay,
                    icon: Icons.access_time_filled_rounded,
                    isSelected: selectedTime != null,
                    onTap: _pickTime,
                  ),
                  
                  const SizedBox(height: 20),
                  _buildLabel("Pesan Pengingat"),
                  TextField(
                    controller: _pesanController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Contoh: Ayo semangat latihan!",
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                      filled: true,
                      fillColor: bgInput,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          child: Text("Batal", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitJadwal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
      ),
    );
  }

  Widget _buildActionTile({
    required String text,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const Color primaryColor = Color(0xFF0C2D57);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.05) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor.withOpacity(0.2) : const Color(0xFFF1F5F9),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? primaryColor : Colors.grey[400], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? primaryColor : Colors.grey[500],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[300], size: 18),
          ],
        ),
      ),
    );
  }
}