import 'package:get/get.dart';

class RecipeController extends GetxController {

  var mealPlan = <String, List<Map<String, String>>>{}.obs;
  var selectedCategory = ''.obs;

  final Map<String, Map<String, List<Map<String, String>>>> recipeDatabase = {

    "mual_tinggi": {

      "Breakfast": [
        {
          "name": "Smoothie Pisang",
          "desc": "Mudah dicerna dan menambah energi"
        }
      ],

      "Lunch": [
        {
          "name": "Sup Ayam Hangat",
          "desc": "Membantu meredakan mual"
        }
      ],

      "Dinner": [
        {
          "name": "Nasi Tim Ayam",
          "desc": "Lembut dan mudah dicerna"
        }
      ],

      "Snack": [
        {
          "name": "Biskuit Gandum",
          "desc": "Snack ringan saat mual"
        },
        {
          "name": "Teh Jahe Hangat",
          "desc": "Anti mual alami"
        }
      ]
    },

    "mual_sedang": {

      "Breakfast": [
        {
          "name": "Roti Gandum + Alpukat",
          "desc": "Energi sehat"
        }
      ],

      "Lunch": [
        {
          "name": "Nasi + Ayam Panggang",
          "desc": "Protein tinggi"
        }
      ],

      "Dinner": [
        {
          "name": "Sup Sayur",
          "desc": "Ringan dan bernutrisi"
        }
      ],

      "Snack": [
        {
          "name": "Buah Apel",
          "desc": "Segar dan membantu pencernaan"
        }
      ]
    },

    "normal": {

      "Breakfast": [
        {
          "name": "Oatmeal + Pisang",
          "desc": "Energi pagi hari"
        }
      ],

      "Lunch": [
        {
          "name": "Nasi + Ikan Panggang",
          "desc": "Omega 3 untuk kesehatan tulang"
        }
      ],

      "Dinner": [
        {
          "name": "Salad Sayur + Telur",
          "desc": "Vitamin lengkap"
        }
      ],

      "Snack": [
        {
          "name": "Yogurt",
          "desc": "Baik untuk pencernaan"
        }
      ]
    }

  };

  void generateMealPlan(String category) {

    selectedCategory.value = category;

    if (recipeDatabase.containsKey(category)) {
      mealPlan.value = recipeDatabase[category]!;
    } else {
      mealPlan.clear();
    }
  }

}