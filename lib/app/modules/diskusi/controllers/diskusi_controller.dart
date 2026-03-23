import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pyhsiocare/app/modules/diskusi/models/post_model.dart';
import 'package:pyhsiocare/config/api_config.dart';

class DiskusiController extends GetxController {
  /// =========================
  /// STATE
  /// =========================

  /// Semua post
  var posts = <Post>[].obs;

  /// Post milik user sendiri
  var myPosts = <Post>[].obs;

  var isLoading = true.obs;

  /// User
  var namaUser = "".obs;
  var fotoUser = "".obs;
  var userId = "".obs;

  /// Controller input post
  TextEditingController postController = TextEditingController();

  /// Image upload
  var selectedImage = Rx<File?>(null);

  final ImagePicker picker = ImagePicker();

  /// =========================
  /// INIT
  /// =========================

  @override
  void onInit() {
    super.onInit();
    loadUser();
    fetchPosts();
  }

  @override
  void onClose() {
    postController.dispose();
    super.onClose();
  }

  /// =========================
  /// LOAD USER DATA
  /// =========================

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    userId.value = prefs.getString("user_id") ?? "";

    if (userId.value.isNotEmpty) {
      await fetchUserProfile();
    }
  }

  /// =========================
  /// FETCH USER PROFILE
  /// =========================

  Future<void> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/user/${userId.value}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        namaUser.value = data["nama"] ?? "Pengguna";
        fotoUser.value = data["foto"] ?? "";
      }
    } catch (e) {
      print("ERROR GET PROFILE: $e");
    }
  }

  /// =========================
  /// PILIH GAMBAR
  /// =========================

  Future pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  /// =========================
  /// GET POSTS
  /// =========================

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(ApiConfig.diskusiUrl),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        /// Semua diskusi
        posts.value = data.map((e) => Post.fromJson(e)).toList();

        /// Filter diskusi milik user
        myPosts.value = posts.where((post) {
          return post.userId == userId.value;
        }).toList();
      }
    } catch (e) {
      print("ERROR FETCH POSTS: $e");
    }

    isLoading.value = false;
  }

  /// =========================
  /// ADD POST
  /// =========================

  Future<void> addPost() async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(ApiConfig.diskusiUrl),
      );

      request.fields["user_id"] = userId.value;
      request.fields["content"] = postController.text;

      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "image",
            selectedImage.value!.path,
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        postController.clear();
        selectedImage.value = null;

        fetchPosts();
      }
    } catch (e) {
      print("ERROR ADD POST: $e");
    }
  }

  /// =========================
  /// COMMENT
  /// =========================

  Future<void> addComment(String postId, String content) async {
    try {
      await http.post(
        Uri.parse(ApiConfig.commentUrl(postId)),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId.value, "content": content}),
      );

      fetchPosts();
    } catch (e) {
      print("ERROR ADD COMMENT: $e");
    }
  }

  /// =========================
  /// LIKE
  /// =========================

  Future<void> likePost(String postId) async {
    try {
      await http.post(
        Uri.parse(ApiConfig.likeUrl(postId)),
      );

      fetchPosts();
    } catch (e) {
      print("ERROR LIKE POST: $e");
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await http.delete(
        Uri.parse("${ApiConfig.diskusiUrl}/$postId"),
      );

      fetchPosts();
    } catch (e) {
      print("ERROR DELETE POST: $e");
    }
  }

  Future<void> editPost(String postId, String content) async {
    try {
      var request = http.MultipartRequest(
        "PUT",
        Uri.parse("${ApiConfig.diskusiUrl}/$postId"),
      );

      request.fields["content"] = content;

      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "image",
            selectedImage.value!.path,
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        selectedImage.value = null;

        fetchPosts();
      }
    } catch (e) {
      print("ERROR EDIT POST: $e");
    }
  }
}
