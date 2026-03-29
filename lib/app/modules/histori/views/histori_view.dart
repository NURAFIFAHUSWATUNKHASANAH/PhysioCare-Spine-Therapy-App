import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/histori_controller.dart';
import 'package:intl/intl.dart';

class HistoriView extends GetView<HistoriController> {
  const HistoriView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF0C2D57);
    const Color accent = Color(0xFFFF8E9E);
    const Color bg = Color(0xFFF6F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text(
          "Riwayat Latihan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.historiList.isEmpty) {
          return const Center(child: Text("Belum ada riwayat latihan"));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchHistory,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              /// HEADER DASHBOARD
              _dashboardCard(primary, accent),

              const SizedBox(height: 25),

              const SizedBox(height: 30),

              const Text(
                "Aktivitas Terakhir",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B)),
              ),

              const SizedBox(height: 15),

              /// LIST HISTORI
              ...controller.historiList.map((h) {
                final tanggal = DateTime.parse(h["tanggal"]);
                final accuracy =
                    double.tryParse(h["accuracy"].toString()) ?? 0;

                return _historyCard(
                  h["label"] ?? "",
                  accuracy,
                  DateFormat('dd MMM yyyy, HH:mm').format(tanggal),
                  primary,
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }

  /// DASHBOARD CARD
  Widget _dashboardCard(Color primary, Color accent) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "PROGRESS LATIHAN",
            style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            "Statistik Latihan",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              _statItem(
                Icons.fitness_center,
                controller.historiList.length.toString(),
                "Total Sesi",
                accent,
              ),

              _statItem(
                Icons.analytics,
                _avgAccuracy(),
                "Rata-rata",
                Colors.white,
              ),

              _statItem(
                Icons.calendar_today,
                "${controller.historiList.length}",
                "Hari Aktif",
                Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _statItem(
      IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        )
      ],
    );
  }

  Widget _infoCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [

          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20),
          ),

          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  /// CARD HISTORI
  Widget _historyCard(
      String label, double accuracy, String date, Color primary) {
    Color statusColor = accuracy >= 80
        ? Colors.green
        : (accuracy >= 60 ? Colors.orange : Colors.red);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.04),
          )
        ],
      ),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.self_improvement, color: primary),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),

                const SizedBox(height: 4),

                Text(
                  date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                )
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                "${accuracy.toStringAsFixed(0)}%",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: statusColor),
              ),

              const Text(
                "Akurasi",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
  }

  String _avgAccuracy() {
    if (controller.historiList.isEmpty) return "0%";

    double total = 0;

    for (var h in controller.historiList) {
      total += double.tryParse(h["accuracy"].toString()) ?? 0;
    }

    double avg = total / controller.historiList.length;

    return "${avg.toStringAsFixed(1)}%";
  }
}