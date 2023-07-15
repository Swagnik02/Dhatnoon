// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// class SimpleAnimation extends StatefulWidget {
//   SimpleAnimation({Key? key}) : super(key: key);

//   @override
//   State<SimpleAnimation> createState() => _SimpleAnimationState();
// }

// class _SimpleAnimationState extends State<SimpleAnimation> {
//   bool _check = false;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             RiveAnimation.asset(
//               'assets/splash_start.riv',
//             ),
//             Positioned(
//               bottom: 255,
//               left: 180,
//               child: Text(
//                 "Log In",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//             Positioned(
//               bottom: 170,
//               left: 170,
//               child: Text(
//                 "Sign Up",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//             Positioned(
//               bottom: 115,
//               left: 150,
//               child: Text(
//                 "Or continue with",
//                 style: TextStyle(color: Colors.white, fontSize: 14),
//               ),
//             ),
//             Positioned(
//               bottom: 53,
//               left: 125,
//               child: Text(
//                 "G",
//                 style: TextStyle(color: Colors.white, fontSize: 23),
//               ),
//             ),
//             Positioned(
//               bottom: 53,
//               right: 125,
//               child: Text(
//                 "f",
//                 style: TextStyle(color: Colors.white, fontSize: 23),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
