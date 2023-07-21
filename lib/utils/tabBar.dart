import 'package:bouncy_widget/bouncy_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/agora_services/front_camera_streaming.dart';
import 'package:components/screens/login.dart';
import 'package:components/screens/profile.dart';
import 'package:components/screens/settings.dart';
import 'package:components/services/audio_player.dart';
import 'package:components/services/audio_record.dart';
import 'package:components/services/front_camera_pic.dart';
import 'package:components/services/front_camera_recording.dart';
import 'package:components/services/photo_page.dart';
import 'package:components/services/rear_camera_pic.dart';
import 'package:components/services/rear_camera_recording.dart';
import 'package:components/services/video_page.dart';
import 'package:components/utils/listWheelScrollView.dart';
import 'package:components/utils/smart_accordion.dart';
import 'package:curved_drawer_fork/curved_drawer_fork.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'dart:io' as iofile;
import 'package:firebase_storage/firebase_storage.dart';

import '../state_management/list_item.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  ListItem listItem = Get.find();

  bool _isOpened = false;

  // for tabs
  late AnimationController _animationController;
  late Animation<double> _progress;

  // All instance of firebase services
  final _user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for hover effect
  late final AnimationController _hoverController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1250))
    ..repeat(reverse: true);
  late Animation<Offset> _hoverAnimation =
      Tween(begin: Offset.zero, end: const Offset(0, 0.02))
          .animate(_hoverController);

  bool isIndex0 = true;
  Time _time = Time(hour: 11, minute: 30, second: 20);

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        // call `build` on animation progress
        setState(() {});
      });

    _progress =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (_isOpened) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    setState(() {
      _isOpened = !_isOpened;
    });
  }

  // Initialize index of drawer item as well as service
  int index = 0;
  String _service = "Live Geo Location";

  // list of custom drawer items
  // final List<DrawerItem> _drawerItems = const <DrawerItem>[
  //   DrawerItem(icon: Icon(Icons.home_outlined), label: "Home"),
  //   DrawerItem(icon: Icon(Icons.person_outline_rounded), label: "Profile"),
  //   DrawerItem(icon: Icon(Icons.logout_rounded), label: "Logout"),
  // ];

  TextEditingController _phoneNumberController = TextEditingController();

  // data to be sent to another user
  var _startTimeHour;
  var _startTimeMinute;
  var _endTimeHour;
  var _endTimeMinute;

  // data will be sent through this dataType
  var _phoneNumber;

  bool dataUploaded = true;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Scaffold(
          // drawer: Placeholder(),
          // drawer: VisibilityDetector(
          //   key: const Key('my-widget-key'),
          //   onVisibilityChanged: (visibilityInfo) {
          //     var visiblePercentage = visibilityInfo.visibleFraction * 100;

          //     // if drawer not opened then route to specific pages based
          //     // on the index value
          //     if (visiblePercentage == 0) {
          //       if (index == 0) Get.to(MyHomePage());
          //       if (index == 1) Get.to(const ProfilePage());
          //       if (index == 2) Get.to(const LogIn());
          //     }
          //   },
          //   // Actual drawer implementation
          //   child: Container(
          //     child: CurvedDrawer(
          //       index: index,
          //       width: 65,
          //       color: Color.fromARGB(255, 69, 3, 130),
          //       buttonBackgroundColor: Color(0xff831d8a),
          //       labelColor: Colors.white,
          //       items: _drawerItems,
          //       onTap: (newIndex) {
          //         setState(() {
          //           index = newIndex;
          //         });
          //       },
          //     ),
          //   ),
          // ),
          drawer: Drawer(
              child: Column(
            children: [
              DrawerHeader(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                    ),
                    Text(
                      'Dhatnoon',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Testing'),
                onTap: () {
                  Get.to(AudioPlayerPro(
                      audioURL:
                          "https://firebasestorage.googleapis.com/v0/b/dhatnoon-backend.appspot.com/o/tanmay_bhai_ka_luck.m4a?alt=media&token=1470f2d8-480d-44b0-abac-f833930c9443"));
                },
              ),
              ListTile(
                leading: const Icon(Icons.send),
                title: const Text('Request'),
                onTap: () {
                  Navigator.pop(context);
                  Get.defaultDialog(
                    title: "Request",
                    textConfirm: "Send",
                    confirmTextColor: Colors.white,
                    textCancel: "Back",
                    onConfirm: () {
                      // setState(() async {
                      //   await
                      // });
                      print("Clicked successfully");
                      addSessionDataToFirebase();
                    },
                    content: Column(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 40,
                          child: TextField(
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              hintText: "Phone number",
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Get.to(ListWheel());
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                              child: Text("Select your choice"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              showPicker(
                                elevation: 20,
                                blurredBackground: true,
                                borderRadius: 50,
                                context: context,
                                value: _time,
                                onChange: onTimeChanged,
                                minuteInterval: TimePickerInterval.FIVE,
                                onChangeDateTime: (DateTime dateTime) {
                                  setState(() {
                                    _startTimeHour = dateTime.hour;
                                    _startTimeMinute = dateTime.minute;
                                  });
                                },
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(57, 8, 57, 8),
                              child: Text("Select start time"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              showPicker(
                                elevation: 20,
                                blurredBackground: true,
                                borderRadius: 50,
                                context: context,
                                value: _time,
                                onChange: onTimeChanged,
                                minuteInterval: TimePickerInterval.FIVE,
                                onChangeDateTime: (DateTime dateTime) {
                                  setState(() {
                                    _endTimeHour = dateTime.hour;
                                    _endTimeMinute = dateTime.minute;
                                  });
                                },
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(60, 8, 60, 8),
                              child: Text("Select end time"),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          )),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff270745),
                    Color(0xff250543),
                    Color(0xff170036),
                    Color(0xff120032),
                    Color(0xff120032),
                  ],
                ),
              ),
            ),
            toolbarHeight: 90,
            titleTextStyle: const TextStyle(
                fontSize: 15, color: Colors.white), // fontsize should be 20
            bottom: TabBar(
              // padding: EdgeInsets.symmetric(horizontal: 120),
              onTap: (value) {
                if (value == 1) {
                  setState(() {
                    isIndex0 = true;
                  });
                } else {
                  setState(() {
                    isIndex0 = false;
                  });
                }
                animate();
              },
              tabs: [
                Container(
                  // decoration: BoxDecoration(
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color:
                  //           isIndex0 ? Color(0xffd33361) : Colors.transparent,
                  //       offset: Offset(0.0, 65),
                  //       blurRadius: 40,
                  //       spreadRadius: 1,
                  //     ),
                  //     BoxShadow(
                  //       color:
                  //           isIndex0 ? Color(0xffcfd8dc) : Colors.transparent,
                  //       offset: Offset(0.0, 130),
                  //       blurRadius: 7,
                  //       spreadRadius: 43,
                  //     ),
                  //   ],
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Tab(
                      icon: Bouncy(
                        duration: const Duration(milliseconds: 2000),
                        lift: isIndex0 ? 10 : 0,
                        ratio: 0.5,
                        pause: 0.5,
                        child: SimpleAnimatedIcon(
                          startIcon: Icons.cloud_download_sharp,
                          endIcon: Icons.refresh,
                          progress: _progress,
                          transitions: const [
                            Transitions.rotate_ccw,
                            Transitions.zoom_in,
                          ],
                        ),
                      ),
                      text: "Fetch",
                    ),
                  ),
                ),
                Container(
                  // decoration: BoxDecoration(
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color:
                  //           isIndex0 ? Colors.transparent : Color(0xffd33361),
                  //       offset: Offset(0.0, 65),
                  //       blurRadius: 40,
                  //       spreadRadius: 1,
                  //     ),
                  //     BoxShadow(
                  //       color:
                  //           isIndex0 ? Colors.transparent : Color(0xffcfd8dc),
                  //       offset: Offset(0.0, 130),
                  //       blurRadius: 7,
                  //       spreadRadius: 43,
                  //     ),
                  //   ],
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Tab(
                      icon: Bouncy(
                        duration: const Duration(milliseconds: 2000),
                        lift: isIndex0 ? 0 : 10,
                        ratio: 0.5,
                        pause: 0.5,
                        child: SimpleAnimatedIcon(
                          startIcon: Icons.hourglass_empty,
                          endIcon: Icons.check_circle_outline,
                          progress: _progress,
                          transitions: [
                            Transitions.zoom_in,
                            Transitions.rotate_ccw
                          ],
                        ),
                      ),
                      text: "Allow",
                    ),
                  ),
                ),
              ],
              labelColor: const Color.fromARGB(255, 255, 255, 255),
              unselectedLabelColor: const Color.fromARGB(255, 92, 91, 91),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: MaterialIndicator(
                color: const Color(0xffd33361),
                height: 5,
                topLeftRadius: 0,
                topRightRadius: 0,
                bottomLeftRadius: 6,
                bottomRightRadius: 6,
                tabPosition: TabPosition.bottom,
              ),
            ),
            title: Text("Hello - ${_user.email!}"),
            // backgroundColor: Colors.black,
            centerTitle: true,
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // Text("ok"),
              AccordionPage(),
              AccordionPage1(),
            ],
          ),
        ),
      ),
    ]);
  }

  addSessionDataToFirebase() async {
    print(_user.email.toString());
    print(_phoneNumberController.text.trim());
    print(_startTimeHour);
    print(_endTimeHour);
    await FirebaseFirestore.instance
        .collection('Sessions')
        .add({
          'senderEmail': _user.email.toString(),
          'ReceiverPhoneNo': _phoneNumberController.text.trim(),
          'startTime_Hours': _startTimeHour,
          'startTime_Minutes': _startTimeMinute,
          'endTime_Hours': _endTimeHour,
          'endTime_minutes': _endTimeMinute,
          'status': 'pending',
          'mode': listItem.listItem.value,
          'shouldSend': false,
          'isComplete': false
        })
        .catchError((e) => {
              Fluttertoast.showToast(
                msg: '${e.toString()}',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.yellow,
              )
            })
        .then((value) => {
              Fluttertoast.showToast(
                  msg: 'Uploaded Successfully!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black,
                  textColor: Colors.white)
            });
    _phoneNumberController.clear();
  }
}
