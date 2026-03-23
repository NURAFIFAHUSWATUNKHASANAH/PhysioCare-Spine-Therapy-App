import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart';

class RecipeView extends StatelessWidget {
  const RecipeView({Key? key}) : super(key: key);

  // --- Theme Colors (Konsisten dengan Fitur Lain) ---
  final Color primaryBlue = const Color(0xFF0C2D57);
  final Color secondaryBlue = const Color(0xFF4361EE);
  final Color bgLight = const Color(0xFFF8FAFC);
  final Color textDark = const Color(0xFF1E293B);
  final Color textGrey = const Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecipeController>();

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryBlue, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Meal Planner Bunda",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (controller.mealPlan.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu_rounded, size: 64, color: textGrey.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text("Belum ada rekomendasi\nmakanan hari ini", 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textGrey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            /// Header Info
            Text(
              "Nutrisi Tepat untuk Bunda",
              style: TextStyle(color: textDark, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              "Menu hari ini disusun berdasarkan kondisi Bunda.",
              style: TextStyle(color: textGrey, fontSize: 14),
            ),
            const SizedBox(height: 24),

            /// Mapping Meal Plan
            ...controller.mealPlan.entries.map((entry) {
              String mealType = entry.key; // e.g., Breakfast, Lunch
              List meals = entry.value;
              int typeIndex = controller.mealPlan.keys.toList().indexOf(mealType);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Meal Type Label (e.g., Breakfast)
                  _buildMealHeader(mealType),
                  const SizedBox(height: 12),

                  /// Meals Card
                  ...meals.asMap().entries.map((mealEntry) {
                    int mealIndex = mealEntry.key;
                    var meal = mealEntry.value;

                    // Animasi Staggered
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 400 + (typeIndex * 200) + (mealIndex * 100)),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: secondaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(Icons.ramen_dining_rounded, color: secondaryBlue),
                          ),
                          title: Text(
                            meal["name"],
                            style: TextStyle(fontWeight: FontWeight.bold, color: textDark),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              meal["desc"],
                              style: TextStyle(color: textGrey, fontSize: 13, height: 1.4),
                            ),
                          ),
                          trailing: Icon(Icons.info_outline_rounded, color: textGrey.withOpacity(0.5), size: 20),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ],
        );
      }),
    );
  }

  /// Label untuk tipe makanan (Breakfast, Lunch, Dinner)
  Widget _buildMealHeader(String label) {
    IconData icon;
    Color color;

    // Logika Ikon & Warna Berdasarkan Waktu
    if (label.toLowerCase().contains('break')) {
      icon = Icons.wb_sunny_outlined;
      color = Colors.orange;
    } else if (label.toLowerCase().contains('lunch')) {
      icon = Icons.light_mode_rounded;
      color = Colors.blue;
    } else {
      icon = Icons.nights_stay_rounded;
      color = Colors.indigo;
    }

    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: color.withOpacity(0.2), thickness: 1)),
      ],
    );
  }
}