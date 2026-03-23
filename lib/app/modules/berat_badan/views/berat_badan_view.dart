import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/berat_badan_controller.dart';

class BeratBadanView extends GetView<BeratBadanController> {
  BeratBadanView({Key? key}) : super(key: key);

  final RxString role = "".obs;

  Future<void> loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    role.value = prefs.getString("user_role") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Load role
    loadRole();

    final controller = Get.isRegistered<BeratBadanController>()
        ? Get.find<BeratBadanController>()
        : Get.put(BeratBadanController());

    final TextEditingController beratInputController =
        TextEditingController();

    const Color primaryColor = Color(0xFF0C2D57);
    const Color accentColor = Color(0xFF2196F3);
    const Color bgColor = Color(0xFFF8FAFF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: primaryColor, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: const Text(
          "Pantau Berat Badan",
          style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: accentColor));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 🔹 HEADER CHART
            SliverToBoxAdapter(
              child: _buildHeaderChart(controller, primaryColor),
            ),

            // 🔹 INPUT (HANYA UNTUK IBU)
            SliverToBoxAdapter(
              child: Obx(() {
                if (role.value == "ibu") {
                  return _buildInputSection(
                    beratInputController,
                    accentColor,
                    primaryColor,
                    controller,
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ),

            // 🔹 HEADER RIWAYAT
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded,
                        size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    const Text(
                      "Riwayat Pengukuran",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: primaryColor),
                    ),
                    const Spacer(),
                    Text(
                      "${controller.riwayat.length} Data",
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 LIST RIWAYAT
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = controller.riwayat[index];
                    return _buildHistoryItem(
                        item, accentColor, primaryColor);
                  },
                  childCount: controller.riwayat.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      }),
    );
  }

  // ================= WIDGET =================

  Widget _buildHeaderChart(
      BeratBadanController controller, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tren Mingguan",
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "${controller.beratTerakhir.value} kg",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(height: 150, child: _buildLineChart(controller)),
          const SizedBox(height: 15),
          const Text(
            "Grafik menunjukkan 7 perubahan berat badan terakhir",
            style: TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(
      TextEditingController input,
      Color accent,
      Color primary,
      BeratBadanController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10)
                ],
              ),
              child: TextField(
                controller: input,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                decoration: InputDecoration(
                  hintText: "Tambah berat baru (kg)...",
                  prefixIcon:
                      Icon(Icons.monitor_weight_outlined, color: accent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              final berat = double.tryParse(input.text);
              if (berat != null && berat > 0) {
                controller.tambahBeratBadan(berat);
                input.clear();
                Get.focusScope?.unfocus();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
      dynamic item, Color accent, Color primary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(Icons.scale_rounded, color: accent),
        title: Text("${item['berat_badan']} kg"),
        subtitle: Text("${item['tanggal']}"),
      ),
    );
  }

  Widget _buildLineChart(BeratBadanController controller) {
    if (controller.riwayat.isEmpty) {
      return const Center(
          child: Text("Data belum tersedia",
              style: TextStyle(color: Colors.white24)));
    }

    var rawData = controller.riwayat.take(7).toList();
    List<Map<String, dynamic>> sorted =
        List.from(rawData.reversed);

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: sorted.asMap().entries.map((e) {
              return FlSpot(
                  e.key.toDouble(),
                  double.tryParse(
                          e.value['berat_badan'].toString()) ??
                      0);
            }).toList(),
            isCurved: true,
            color: Colors.white,
            barWidth: 4,
          ),
        ],
      ),
    );
  }
}