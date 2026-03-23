import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/informasi_controller.dart';

class InformasiView extends StatelessWidget {
  final InformasiController controller = Get.put(InformasiController());

  @override
  Widget build(BuildContext context) {
    const Color kMidnightBlue = Color(0xFF0C2D57);
    const Color kRosePink = Color(0xFFFF8E9E);
    const Color kBgColor = Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Obx(() {
          // 🔥 kalau di detail → balik ke list
          if (controller.selectedData.value != null) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kMidnightBlue, size: 20),
              onPressed: () => controller.clearSelected(),
            );
          }

          // 🔥 kalau di list → balik page sebelumnya
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kMidnightBlue, size: 20),
            onPressed: () => Get.back(),
          );
        }),
        title: const Text(
          "Informasi",
          style: TextStyle(
            color: kMidnightBlue,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),

      // 🔥 BODY DINAMIS
      body: Obx(() {
        // =====================
        // 🔥 DETAIL VIEW
        // =====================
        if (controller.selectedData.value != null) {
          return _buildDetail(controller.selectedData.value!, kMidnightBlue);
        }

        // =====================
        // 🔥 EMPTY
        // =====================
        if (controller.informasiList.isEmpty) {
          return _buildEmptyState(kMidnightBlue);
        }

        // =====================
        // 🔥 LIST VIEW
        // =====================
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.informasiList.length,
          itemBuilder: (context, index) {
            final data = controller.informasiList[index];

            return GestureDetector(
              onTap: () => controller.selectData(data), // 🔥 klik → detail
              child: _buildInfoCard(data, kMidnightBlue, kRosePink),
            );
          },
        );
      }),
    );
  }

  // =====================
  // 🔥 CARD LIST
  // =====================
  Widget _buildInfoCard(dynamic data, Color primary, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 90,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.notifications_active_rounded, color: accent),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["pesan"] ?? "-",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(data["tanggal"]),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================
  // 🔥 DETAIL VIEW
  // =====================
  Widget _buildDetail(dynamic data, Color primary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detail Informasi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              data["pesan"] ?? "-",
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  _formatDate(data["tanggal"]),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =====================
  // 🔥 EMPTY STATE
  // =====================
  Widget _buildEmptyState(Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: color.withOpacity(0.2)),
          const SizedBox(height: 20),
          Text(
            "Belum ada informasi",
            style: TextStyle(color: color.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "-";
    return dateStr.length > 10 ? dateStr.substring(0, 10) : dateStr;
  }
}