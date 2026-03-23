import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ukuran_janin_controller.dart';

class UkuranJaninView extends GetView<UkuranJaninController> {
  const UkuranJaninView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0C2D57);
    const Color accentColor = Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Ukuran Janin",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Header Ringkasan
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      "Usia Kehamilan Anda",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "${controller.mingguUser.value} Minggu",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Card Visual Buah
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0C2D57), Color(0xFF2D5A97)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -30,
                            top: -30,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.auto_awesome, color: Colors.amber, size: 28),
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        "Seukuran ${controller.buah.value}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildInfoDetail(Icons.straighten_rounded, "Panjang", controller.panjang.value),
                                      VerticalDivider(color: Colors.white.withOpacity(0.2), thickness: 1),
                                      _buildInfoDetail(Icons.scale_rounded, "Berat", controller.berat.value),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: Text(
                                    controller.deskripsi.value,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.6,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Judul Timeline
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Text(
                  "Timeline Perkembangan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
              ),
            ),

            // 3. List Perkembangan
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final weekList = controller.perkembanganJanin.keys.toList();
                    final week = weekList[index];
                    bool isSelected = controller.selectedWeek.value == week;
                    bool isCurrent = controller.mingguUser.value == week;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? accentColor : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected 
                          ? [BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
                          : [],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onTap: () => controller.setPerkembangan(week),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected ? accentColor : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              "$week",
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              "Minggu $week",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? primaryColor : Colors.black87,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "SEKARANG",
                                  style: TextStyle(color: Colors.green[700], fontSize: 9, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ]
                          ],
                        ),
                        subtitle: Text(
                          "Seukuran ${controller.perkembanganJanin[week]!["buah"]}",
                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
                        trailing: Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
                          color: isSelected ? accentColor : Colors.grey[300],
                        ),
                      ),
                    );
                  },
                  childCount: controller.perkembanganJanin.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        );
      }),
    );
  }

  Widget _buildInfoDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}