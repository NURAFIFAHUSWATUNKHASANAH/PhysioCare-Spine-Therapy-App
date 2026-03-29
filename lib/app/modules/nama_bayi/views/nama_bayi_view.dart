import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nama_bayi_controller.dart';

class NamaBayiView extends GetView<NamaBayiController> {
  NamaBayiView({super.key});

  // Palette Warna Profesional & Manis
  final Color primaryDark = const Color(0xFF0C2D57);
  final Color accentPink = const Color(0xFFFF8E9E); // Pink dari fitur Meditasi
  final Color bgLight = const Color(0xFFF8FAFC);
    final Color grey = const Color.fromARGB(255, 168, 166, 166);
  final TextEditingController keywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgLight,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildMainTab(),
                  _buildFavoriteTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================================
  /// HEADER & NAVIGASI
  /// ================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 90,
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Koleksi Nama",
              style: TextStyle(
                color: grey, // Sentuhan pink di sub-title
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Buah Hati Bunda",
              style: TextStyle(
                color: primaryDark,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: primaryDark.withOpacity(0.4),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [primaryDark, primaryDark.withOpacity(0.8)],
          ),
        ),
        tabs: const [
          Tab(
            height: 48,
            child: Text("Eksplorasi",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
          Tab(
            height: 48,
            child: Text("Favorit",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  /// ================================
  /// TAB UTAMA
  /// ================================

  Widget _buildMainTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          _buildSectionHeader("Kriteria Nama"),
          const SizedBox(height: 20),
          _buildInputWrapper(
            icon: Icons.auto_fix_high_rounded,
            color: accentPink, // Icon pencarian jadi pink
            child: TextField(
              controller: keywordController,
              onChanged: (v) => controller.keyword.value = v,
              style: TextStyle(color: primaryDark, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "Cari makna (Cth: Cerdas, Berani...)",
                hintStyle: TextStyle(
                    color: Colors.grey[400], fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildDropdownSelector(
                      "Kategori", controller.category, Icons.language_rounded)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDropdownSelector(
                      "Gender", controller.gender, Icons.wc_rounded)),
            ],
          ),
          const SizedBox(height: 32),
          _buildActionButton(),
          const SizedBox(height: 40),
          _buildSectionHeader("Rekomendasi Terbaik"),
          const SizedBox(height: 20),
          _buildResultsArea(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  /// ================================
  /// KOMPONEN UI 
  /// ================================

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: primaryDark.withOpacity(0.5),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Divider(color: accentPink.withOpacity(0.2), thickness: 1)),
      ],
    );
  }

  Widget _buildInputWrapper(
      {required IconData icon, required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 14),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildDropdownSelector(
      String label, RxString obsValue, IconData icon) {
    return Obx(() => _buildInputWrapper(
          icon: icon,
          color: primaryDark.withOpacity(0.5),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: obsValue.value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: accentPink.withOpacity(0.5)),
              style: TextStyle(
                  color: primaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
              items: (label == "Kategori"
                      ? ["Islami", "Modern", "Jawa", "Internasional"]
                      : ["Laki-laki", "Perempuan"])
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => obsValue.value = v!,
            ),
          ),
        ));
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: () => controller.generateNama(),
        child: const Text(
          "Cari Nama Sekarang",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.1),
        ),
      ),
    );
  }

  Widget _buildResultsArea() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: CircularProgressIndicator(color: accentPink, strokeWidth: 3),
          ),
        );
      }
      final names = controller.parsedNames;
      if (names.isEmpty) return _buildEmptyState("Cari kriteria nama Bunda...");

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: names.length,
itemBuilder: (context, index) {
  final name = names[index]["name"]!;
  final meaning = names[index]["meaning"]!;

  return _buildModernNameCard(
    name,
    meaning,
    isFavorite: controller.isFavorite(name), // 🔥 DINAMIS
  );
},
      );
    });
  }

  Widget _buildModernNameCard(String name, String meaning,
      {required bool isFavorite}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryDark.withOpacity(0.05)),
        boxShadow: [
           BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accentPink.withOpacity(0.1), // Background inisial jadi pink soft
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                name[0],
                style: TextStyle(
                    color: accentPink, // Huruf inisial pink
                    fontWeight: FontWeight.w900,
                    fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: primaryDark),
                ),
                const SizedBox(height: 4),
                Text(
                  meaning,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[600], height: 1.4),
                ),
              ],
            ),
          ),
          _buildFavoriteToggle(name, meaning, isFavorite),
        ],
      ),
    );
  }

  Widget _buildFavoriteToggle(String name, String meaning, bool isFavorite) {
  return InkWell(
    onTap: () async {
      if (isFavorite) {
        await controller.removeFavorite(name);
      } else {
        await controller.saveFavorite(name, meaning);
      }
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isFavorite ? accentPink : Colors.grey[300],
        size: 28,
      ),
    ),
  );
}

  Widget _buildFavoriteTab() {
    return Obx(() {
      if (controller.favorites.isEmpty)
        return _buildEmptyState("Bunda belum menyimpan nama favorit.");

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
        physics: const BouncingScrollPhysics(),
        itemCount: controller.favorites.length,
        itemBuilder: (context, index) {
          final item = controller.favorites[index];
          return _buildModernNameCard(item["name"] ?? "", item["meaning"] ?? "",
              isFavorite: true);
        },
      );
    });
  }

  Widget _buildEmptyState(String msg) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Icon(Icons.auto_awesome_outlined, size: 60, color: accentPink.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(msg,
              style: TextStyle(color: primaryDark.withOpacity(0.4), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}