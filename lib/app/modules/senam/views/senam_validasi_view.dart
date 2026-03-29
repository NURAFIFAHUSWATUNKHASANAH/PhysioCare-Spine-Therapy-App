import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'senam_session_view.dart';

class SenamValidasiView extends StatefulWidget {
  final String title;
  final String image;
  final String desc;

  const SenamValidasiView({
    super.key,
    required this.title,
    required this.image,
    required this.desc,
  });

  @override
  State<SenamValidasiView> createState() => _SenamValidasiViewState();
}

class _SenamValidasiViewState extends State<SenamValidasiView> {
  bool nyeriPerutHebat = false;
  bool perdarahanVagina = false;
  bool pusingHebat = false;
  bool sesakNapass = false;

  final Color kMidnightBlue = const Color(0xFF0C2D57);
  final Color kRosePink = const Color(0xFFFF8E9E);
  final Color kBackground = const Color(0xFFFBFDFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          "Validasi Kondisi",
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        backgroundColor: Colors.white,
        foregroundColor: kMidnightBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kRosePink.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.health_and_safety_rounded, color: kRosePink, size: 40),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Keamanan Anda Prioritas Kami",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0C2D57),
                    letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Text(
                "Mohon jawab setiap pertanyaan berikut dengan 'Iya' atau 'Tidak' sebelum memulai sesi:",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Checkbox / Toggle pertanyaan
              _buildYesNoQuestion(
                title: "Nyeri/Kram Hebat",
                subtitle: "Di perut bagian bawah atau punggung",
                value: nyeriPerutHebat,
                onChanged: (val) => setState(() => nyeriPerutHebat = val),
              ),
              _buildYesNoQuestion(
                title: "Perdarahan",
                subtitle: "Keluarnya flek atau darah dari vagina",
                value: perdarahanVagina,
                onChanged: (val) => setState(() => perdarahanVagina = val),
              ),
              _buildYesNoQuestion(
                title: "Pusing / Pandangan Kabur",
                subtitle: "Atau merasa ingin pingsan",
                value: pusingHebat,
                onChanged: (val) => setState(() => pusingHebat = val),
              ),
              _buildYesNoQuestion(
                title: "Gangguan Pernapasan",
                subtitle: "Sesak napas atau napas terasa sangat cepat",
                value: sesakNapass,
                onChanged: (val) => setState(() => sesakNapass = val),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _handleValidation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMidnightBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 8,
                    shadowColor: kMidnightBlue.withOpacity(0.3),
                  ),
                  child: const Text(
                    "MULAI LATIHAN SEKARANG",
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.1),
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

  Widget _buildYesNoQuestion({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? kRosePink.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value ? kRosePink : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kMidnightBlue),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              ],
            ),
          ),
          Row(
            children: [
              // Tombol “Tidak”
              GestureDetector(
                onTap: () => onChanged(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: !value ? kRosePink : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Tidak", style: TextStyle(color: !value ? Colors.white : kMidnightBlue)),
                ),
              ),
              const SizedBox(width: 8),
              // Tombol “Iya”
              GestureDetector(
                onTap: () => onChanged(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: value ? kRosePink : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Iya", style: TextStyle(color: value ? Colors.white : kMidnightBlue)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleValidation() {
    if (nyeriPerutHebat || perdarahanVagina || pusingHebat || sesakNapass) {
      Get.snackbar(
        "Latihan Tidak Disarankan",
        "Demi keselamatan Anda, mohon konsultasikan gejala ini dengan dokter sebelum berlatih.",
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP, // Muncul di atas
        margin: const EdgeInsets.all(16),
        borderRadius: 15,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } else {
      Get.to(() => SenamSessionView(
            title: widget.title,
            image: widget.image,
            desc: widget.desc,
          ));
    }
  }
}