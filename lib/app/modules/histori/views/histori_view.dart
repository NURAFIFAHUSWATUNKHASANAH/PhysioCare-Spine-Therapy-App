import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/histori_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoriView extends StatelessWidget {
  const HistoriView({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoriController controller = Get.find();
    
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF), // Senada dengan HomeView
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0C2D57), size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Riwayat Latihan",
          style: TextStyle(color: Color(0xFF0C2D57), fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Chart Section (Visual Utama)
            const Text(
              "Analisis Akurasi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Obx(() {
                final labels = controller.averageByLabel.keys.toList();
                final data = controller.averageByLabel.values.toList();

                return Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: labels.isNotEmpty
                          ? _buildBarChart(data, labels)
                          : const Center(child: Text("Belum ada data grafik", style: TextStyle(color: Color(0xFF94A3B8)))),
                    ),
                    if (labels.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      const Text(
                        "Rata-rata akurasi per jenis gerakan (%)",
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                      ),
                    ]
                  ],
                );
              }),
            ),

            const SizedBox(height: 25),

            // 2. Statistik Bento Cards
            const Text(
              "Ringkasan Performa",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 15),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        "Total Latihan",
                        "${controller.historyList.length}",
                        "Sesi Selesai",
                        Icons.history_rounded,
                        const Color(0xFF0C2D57),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _statCard(
                        "Rerata Skor",
                        "${_averageAccuracy(controller.historyList)}%",
                        "Tingkat Akurasi",
                        Icons.analytics_rounded,
                        const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                )),

            const SizedBox(height: 30),

            // 3. List Riwayat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Aktivitas Terakhir",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
                Icon(Icons.sort_rounded, color: Colors.grey[400], size: 20),
              ],
            ),
            const SizedBox(height: 15),
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.historyList.length,
                  itemBuilder: (context, index) {
                    final item = controller.historyList[index];
                    return _historyCard(
                      item["label"] ?? "Terapi",
                      item["tanggal"] ?? "Tanggal tidak tersedia",
                      (item["accuracy"] ?? 0).toDouble(),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<double> data, List<String> labels) {
    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        barGroups: List.generate(data.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data[i],
                width: 22,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                color: const Color(0xFF0C2D57),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 100,
                  color: const Color(0xFFF1F5F9),
                ),
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      labels[index].length > 8 ? '${labels[index].substring(0, 5)}..' : labels[index],
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
              reservedSize: 35,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: const Color(0xFFE2E8F0),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, String sub, IconData icon, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: accentColor.withOpacity(0.1),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(height: 15),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _historyCard(String terapi, String tanggal, double akurasi) {
    Color statusColor = akurasi >= 80 ? Colors.green : (akurasi >= 60 ? Colors.orange : Colors.red);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF0C2D57)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(terapi, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 5),
                    Text(tanggal, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${akurasi.toStringAsFixed(1)}%",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: statusColor),
              ),
              const Text("Akurasi", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  String _averageAccuracy(List<Map<String, dynamic>> list) {
    if (list.isEmpty) return "0.0";
    double sum = 0;
    int count = 0;
    for (var e in list) {
      if (e["accuracy"] != null) {
        sum += (e["accuracy"] as num).toDouble();
        count++;
      }
    }
    return count == 0 ? "0.0" : (sum / count).toStringAsFixed(1);
  }
}