import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile screen")),
      body: Center(
        child: Text(
          "Profile Screen",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
