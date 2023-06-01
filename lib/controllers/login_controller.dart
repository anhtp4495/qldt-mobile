import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import '/constants/api_endpoints.dart';
import '/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void onReady() async {
    super.onReady();

    final SharedPreferences prefs = await _prefs;
    Object? accessToken = prefs.get("access_token");
    if (accessToken != null) {
      Get.off(const HomeScreen());
    }
  }

  Future<void> login() async {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse(ApiEndpoints.instance.tokenEndpoint);
    Map body = {
      'username': usernameController.text.trim(),
      'password': passwordController.text.trim()
    };

    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        String accesToken = json['access_token'];

        final SharedPreferences prefs = await _prefs;
        prefs.setString("access_token", accesToken);

        usernameController.clear();
        passwordController.clear();

        Get.off(const HomeScreen());
      } else {
        throw json["error_message"] ?? "Unknown error occurred";
      }
    } catch (err) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("Lỗi".toUpperCase()),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(err.toString())],
            );
          });
    }
  }
}
