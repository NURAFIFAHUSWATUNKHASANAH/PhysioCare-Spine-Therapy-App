import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml untuk format tanggal
import '../controllers/validasi_kehamilan_controller.dart';

class ValidasiKehamilanView extends GetView<ValidasiKehamilanController> {
  const ValidasiKehamilanView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryDark = Color(0xFF0C2D57);
    final Color fieldFillColor = primaryDark.withOpacity(0.05);

    // Controller untuk menampilkan teks tanggal di field
    final TextEditingController dateController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Data Kehamilan",
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2, color: primaryDark),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryDark, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: fieldFillColor, shape: BoxShape.circle),
                  child: const Icon(Icons.health_and_safety_outlined, size: 40, color: primaryDark),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Informasi Kesehatan",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryDark),
              ),
              const SizedBox(height: 4),
              Text(
                "Lengkapi data di bawah ini untuk pemantauan kesehatan yang lebih akurat.",
                style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 32),

              // FIELD HPHT DENGAN DATE PICKER
              _buildInputLabel("Hari Pertama Haid Terakhir (HPHT)"),
              TextField(
                controller: dateController,
                readOnly: true, // Mencegah keyboard muncul
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: primaryDark, // Warna header kalender
                            onPrimary: Colors.white, // Warna teks header
                            onSurface: primaryDark, // Warna teks tanggal
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    // Format tanggal agar cantik: YYYY-MM-DD
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    dateController.text = formattedDate;
                    controller.setHpht(formattedDate);
                  }
                },
                decoration: _inputStyle(
                  hint: "Pilih Tanggal",
                  icon: Icons.calendar_month_rounded,
                  fillColor: fieldFillColor,
                ),
              ),
              
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Tinggi Badan"),
                        _buildCustomField(
                          hint: "cm",
                          icon: Icons.straighten_rounded,
                          fillColor: fieldFillColor,
                          keyboardType: TextInputType.number,
                          onChanged: controller.setTinggi,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("Berat Badan"),
                        _buildCustomField(
                          hint: "kg",
                          icon: Icons.scale_rounded,
                          fillColor: fieldFillColor,
                          keyboardType: TextInputType.number,
                          onChanged: controller.setBerat,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _buildInputLabel("Riwayat Penyakit"),
              _buildCustomField(
                hint: "Contoh: Diabetes, Asma, atau -",
                icon: Icons.description_outlined,
                fillColor: fieldFillColor,
                onChanged: controller.setPenyakit,
              ),

              const SizedBox(height: 48),

              // Professional Action Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: primaryDark.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Simpan Data Sekarang",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0C2D57)),
      ),
    );
  }

  // Abstraksi Dekorasi Input agar konsisten
  InputDecoration _inputStyle({required String hint, required IconData icon, required Color fillColor}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF0C2D57), size: 22),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF0C2D57), width: 1.5),
      ),
    );
  }

  Widget _buildCustomField({
    required String hint,
    required IconData icon,
    required Color fillColor,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
      decoration: _inputStyle(hint: hint, icon: icon, fillColor: fillColor),
    );
  }
}