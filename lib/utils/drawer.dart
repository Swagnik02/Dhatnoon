// custom drawer widget which would be present for the home
// screen

import 'package:components/screens/profile.dart';
import 'package:components/screens/splash.dart';
import 'package:components/services/front_camera_pic.dart';
import 'package:curved_drawer_fork/curved_drawer_fork.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Initialize index of drawer item
  int index = 0;

  // list of custom drawer items
  final List<DrawerItem> _drawerItems = const <DrawerItem>[
    DrawerItem(icon: Icon(Icons.home_outlined), label: "Home"),
    DrawerItem(icon: Icon(Icons.person_outline_rounded), label: "Profile"),
    DrawerItem(icon: Icon(Icons.logout_rounded), label: "Logout"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // check if drawer is open or closed
      drawer: VisibilityDetector(
        key: const Key('my-widget-key'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;

          // if drawer not opened then route to specific pages based
          // on the index value
          if (visiblePercentage == 0) {
            if (index == 0) Get.to(const CustomDrawer());
            if (index == 1) Get.to(const ProfilePage());
            if (index == 2) Get.to(const SplashScreen());
          }
        },
        // Actual drawer implementation
        child: CurvedDrawer(
            index: index,
            width: 65,
            color: Colors.blue,
            buttonBackgroundColor: Colors.blue,
            labelColor: Colors.white,
            items: _drawerItems,
            onTap: (newIndex) {
              setState(() {
                index = newIndex;
              });
              
            },
          ),
        ),

      // content other than the drawer
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'Current index is $index',
      //         style: TextStyle(fontSize: 30),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
