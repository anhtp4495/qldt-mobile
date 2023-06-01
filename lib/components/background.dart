import 'package:flutter/material.dart';

class AppbarBackground extends StatelessWidget {
  final Widget child;
  final String title;
  const AppbarBackground({Key? key, required this.child, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: child,
        backgroundColor: Colors.grey.shade200);
  }
}
