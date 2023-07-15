import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings screen")),
      body: const Center(
        child: Text(
          "Settings",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
