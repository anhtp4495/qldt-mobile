import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/views/attendance_event_screen.dart';
import '/views/attendance_manager_screen.dart';
import 'package:get/get.dart';
import '/views/login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<Widget> _screens = [
    const AttendanceManagerScreen(),
    const AttendanceEventScreen(),
    const HomeScreen()
  ];

  final destinations = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.home_work_outlined), label: "Hoạt động"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.work_history_outlined), label: "Điểm danh"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.logout_outlined), label: "Thoát"),
  ];

  int _currentScreenIndex = 0;

  handleDestinationSelected(int index) async {
    if (index == destinations.length - 1) {
      final SharedPreferences prefs = await _prefs;
      prefs.remove("access_token");
      Get.off(const LoginScreen());
    } else {
      setState(() {
        _currentScreenIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        onTap: handleDestinationSelected,
        items: destinations,
        currentIndex: _currentScreenIndex,
      ),
      body: _screens[_currentScreenIndex],
    );
  }
}
