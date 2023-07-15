import 'dart:io' as iofile;
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/agora_services/audio_streaming.dart';
import 'package:components/agora_services/front_camera_streaming.dart';
import 'package:components/agora_services/rear_camera_streaming.dart';
import 'package:components/services/audio_player.dart';
import 'package:components/services/audio_record.dart';
import 'package:components/services/front_camera_pic.dart';
import 'package:components/services/front_camera_recording.dart';
import 'package:components/services/photo_page.dart';
import 'package:components/services/rear_camera_pic.dart';
import 'package:components/services/rear_camera_recording.dart';
import 'package:components/services/video_page.dart';
import 'package:components/state_management/iconChange.dart';
import 'package:components/state_management/state_of_back_cam_pic.dart';
import 'package:components/state_management/state_of_back_cam_rec.dart';
import 'package:components/state_management/state_of_front_cam_pic.dart';
import 'package:components/state_management/state_of_front_cam_rec.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AccordionPage extends StatefulWidget //__
{
  const AccordionPage({Key? key}) : super(key: key);

  @override
  State<AccordionPage> createState() => _AccordionPageState();
}

class _AccordionPageState extends State<AccordionPage> {
  IconChange _iconChange = IconChange();
  final _user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final _headerStyle = const TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 15,
      fontWeight: FontWeight.bold);

  @override
  build(context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Accordion(
            maxOpenSections: 1,
            // headerBackgroundColorOpened: Colors.black54,
            headerPadding:
                const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: [
              AccordionSection(
                paddingBetweenOpenSections: 20,
                paddingBetweenClosedSections: 20,
                headerPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                rightIcon: const Icon(
                  Icons.remove_circle,
                  color: Color(0xff250543),
                ),
                headerBorderRadius: 25,
                isOpen: true,
                headerBackgroundColor: Colors.white,
                headerBackgroundColorOpened: Colors.white,
                header: Text('Approved requests', style: _headerStyle),
                content: FetchedAcceptedRequest(),
                contentHorizontalPadding: 20,
                contentBorderWidth: 1,
                contentBorderColor: Colors.white,
                contentBorderRadius: 25,
              ),
              AccordionSection(
                paddingBetweenOpenSections: 20,
                paddingBetweenClosedSections: 20,
                headerPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                rightIcon: Obx(
                  () => _iconChange.isAccordionOpen.value
                      ? const Icon(
                          Icons.remove_circle,
                          color: Color(0xff250543),
                        )
                      : const Icon(
                          Icons.add_circle,
                          color: Color(0xff250543),
                        ),
                ),
                headerBorderRadius: 25,
                isOpen: false,
                headerBackgroundColor: Colors.white,
                headerBackgroundColorOpened: Colors.white,
                header: Text('List of pending or rejected requests',
                    style: _headerStyle),
                content: FetchPendingOrRejectedRequest(),
                contentHorizontalPadding: 20,
                contentBorderWidth: 1,
                contentBorderColor: Colors.white,
                contentBorderRadius: 25,
                onCloseSection: () {
                  _iconChange.accordionClosed();
                },
                onOpenSection: () {
                  _iconChange.accordionOpened();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  FetchPendingOrRejectedRequest() {
    final RequestData = FirebaseFirestore.instance
        .collection('Sessions')
        .where("senderEmail", isEqualTo: _user.email)
        .where("status", isNotEqualTo: "Approved")
        .snapshots();
    return SizedBox(
      height: 128,
      child: StreamBuilder(
        stream: RequestData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((document) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [const BoxShadow(blurRadius: 12)],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.black, width: 0.2),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Sender - ${document['senderEmail']}"),
                    ),
                    Container(
                      child: Text(
                          "Start time - ${document['startTime_Hours'].toString()}:${document['startTime_Minutes'].toString()}"),
                    ),
                    Container(
                      child: Text(
                          "End time - ${document['endTime_Hours'].toString()}:${document['endTime_minutes'].toString()}"),
                    ),
                    Container(
                      child: Text("Phone No - ${document['ReceiverPhoneNo']}"),
                    ),
                    Container(
                      child: Text("Status - ${document['status']}"),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  FetchedAcceptedRequest() {
    final RequestData = FirebaseFirestore.instance
        .collection('Sessions')
        .where("senderEmail", isEqualTo: _user.email)
        .where("status", isEqualTo: "Approved")
        .snapshots();

    return SizedBox(
      height: 190,
      child: StreamBuilder(
        stream: RequestData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((document) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [const BoxShadow(blurRadius: 12)],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: Colors.black, width: 0.2),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Sender - ${document['senderEmail']}"),
                    ),
                    Container(
                      child: Text("Mode - ${document['mode']}"),
                    ),
                    Container(
                      child: Text(
                          "Start time - ${document['startTime_Hours']}:${document['startTime_Minutes']}"),
                    ),
                    Container(
                      child: Text(
                          "End time - ${document['endTime_Hours']}:${document['endTime_minutes']}"),
                    ),
                    Container(
                      child: Text("Phone No - ${document['ReceiverPhoneNo']}"),
                    ),
                    Container(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        label: const Text("View"),
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        onPressed: () async {
                          print("tap working");

                          firestore
                              .collection("Sessions")
                              .doc(document.id)
                              .update(
                              {'shouldSend': true});
                          /*
                          -> doc['send'] = true

                          -> wait till data gets updated in firebase

                          -> then launch respective widgets

                          -> doc['send'] = false
                           */

                          if(document['isComplete'] == true){

                            if (document['mode'] == 'Live Geo Location') {
                              Get.to(MapWala(
                                latitude: double.parse(document['latitude']),
                                longitude: double.parse(document['longitude']),
                              ));
                            }
                            if (document['mode'] == 'Front Camera Pic') {
                              Get.to(DisplayPictureScreen(
                                  imagePath: document['frontImgURL'],
                                  cameraMode: 'Front'));

                            }
                            if (document['mode'] == 'Back Camera Pic') {
                              Get.to(DisplayPictureScreen(
                                  imagePath: document['backImgURL'],
                                  cameraMode: 'Back'));
                            }
                            if (document['mode'] ==
                                'Front Camera 10 Second Video') {
                              Get.to(
                                VideoPage(
                                    videoLink: document['frontVideoURL'],
                                    videoMode: "Front"),
                              );
                              // idar click karne ke baad video play hoga
                            }
                            if (document['mode'] ==
                                'Back Camera 10 Second Video') {
                              Get.to(
                                VideoPage(
                                    videoLink: document['backVideoURL'],
                                    videoMode: "Back"),
                              );
                              // idar click karne ke baad video play hoga
                            }

                            if (document['mode'] == 'Front Camera Streaming') {
                              Get.to(FrontRecieverStream());
                            }
                            if (document['mode'] == 'Back Camera Streaming') {
                              Get.to(BackRecieverStream());
                            }
                            if (document['mode'] == 'Audio Live Streaming') {
                              Get.to(AudioRecieverStream());
                            }
                            if (document['mode'] == '10 Second Audio Recording') {
                              Get.to(
                                  AudioPlayerPro(audioURL: document['audioURL']));
                            }
                          }
                          else{
                            Get.defaultDialog(
                              title: "Receiving data from ${document['ReceiverPhoneNo']}",
                              content: const Text("Please open after some time")
                            );
                          }


                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class AccordionPage1 extends StatefulWidget //__
{
  const AccordionPage1({Key? key}) : super(key: key);

  @override
  State<AccordionPage1> createState() => _AccordionPage1State();
}

class _AccordionPage1State extends State<AccordionPage1> {
  final _user = FirebaseAuth.instance.currentUser!;
  String _phoneNo = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  StateOfFrontCamPic stateOfFrontCamPic = Get.find();
  StateOfBackCamPic stateOfBackCamPic = Get.find();

  StateOfFrontCamRec stateOfFrontCamRec = Get.find();
  StateOfBackCamRec stateOfBackCamRec = Get.find();

  final _headerStyle = const TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 15,
      fontWeight: FontWeight.bold);

  @override
  build(context) {
    firestore
        .collection('userInfo')
        .where("useremail", isEqualTo: _user.email.toString())
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _phoneNo = doc['phone'];
      });
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Accordion(
            maxOpenSections: 1,
            headerBackgroundColorOpened: Colors.black54,
            headerPadding:
                const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: [
              AccordionSection(
                paddingBetweenOpenSections: 20,
                paddingBetweenClosedSections: 20,
                headerPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                rightIcon: const Icon(
                  Icons.add_circle,
                  color: Color.fromARGB(255, 11, 61, 102),
                ),
                headerBorderRadius: 25,
                isOpen: true,
                // leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
                headerBackgroundColor: Colors.white,
                headerBackgroundColorOpened: Colors.white,
                header: Text('Requests sent to you', style: _headerStyle),
                content: FetchAllRequest(),
                contentHorizontalPadding: 20,
                contentBorderWidth: 1,
                contentBorderColor: Colors.white,
                contentBorderRadius: 25,
                onCloseSection: () => print('onCloseSection ...'),
              ),
              AccordionSection(
                paddingBetweenOpenSections: 20,
                paddingBetweenClosedSections: 20,
                headerPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                rightIcon: const Icon(
                  Icons.add_circle,
                  color: Color.fromARGB(255, 11, 61, 102),
                ),
                headerBorderRadius: 25,
                isOpen: false,
                headerBackgroundColor: Colors.white,
                headerBackgroundColorOpened: Colors.white,
                header: Text('List of pending or rejected requests',
                    style: _headerStyle),
                content: FetchUnansweredRequest(),
                contentHorizontalPadding: 20,
                contentBorderWidth: 1,
                contentBorderColor: Colors.white,
                contentBorderRadius: 25,
                onCloseSection: () => print('onCloseSection ...'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FetchAllRequest() {
    final RequestData = FirebaseFirestore.instance
        .collection('Sessions')
        .where("ReceiverPhoneNo", isEqualTo: _phoneNo)
        .snapshots();
    print(_phoneNo);
    return SizedBox(
      height: 150,
      child: StreamBuilder(
        stream: RequestData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((document) {
              print("entered");
              //show notification
              // AwesomeNotifications().createNotification(
              //     content: NotificationContent(
              //       id: 123,
              //       channelKey: 'basic',
              //       title: "From - ${document['senderEmail']}",
              //       body: "need access to \n ${document['mode']} mode",
              //       payload: {"name": "FlutterCampus"},
              //       autoDismissible: false,
              //       displayOnBackground: true,
              //       fullScreenIntent: true,
              //     ),
              //     actionButtons: [
              //       NotificationActionButton(
              //           key: "close",
              //           label: "Ok",
              //           buttonType: ActionButtonType.DisabledAction),
              //     ]);
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [const BoxShadow(blurRadius: 12)],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.black, width: 0.2),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Sender - ${document['senderEmail']}"),
                    ),
                    Container(
                      child: Text("Mode - ${document['mode']}"),
                    ),
                    Container(
                      child: Text(
                          "Start time - ${document['startTime_Hours']}:${document['startTime_Minutes']}"),
                    ),
                    Container(
                      child: Text(
                          "End time - ${document['endTime_Hours']}:${document['endTime_minutes']}"),
                    ),
                    (document['status'] == 'Approved')
                        ? Container(
                            child: Text("Accepted",
                                style: TextStyle(color: Colors.green.shade600)))
                        : (document['status'] == 'rejected')
                            ? Container(
                                child: Text("Rejected",
                                    style:
                                        TextStyle(color: Colors.red.shade600)))
                            : Container(
                                width: 235,
                                child: Row(
                                  children: [
                                    ElevatedButton.icon(
                                      label: const Text("Accept"),
                                      icon: const Icon(
                                          Icons.check_circle_outline),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        firestore
                                            .collection("Sessions")
                                            .doc(document.id)
                                            .update({'status': 'Approved'});

                                        if (document['shouldSend'] == true){

                                          if (document['mode'] ==
                                              'Live Geo Location') {
                                            _determinePosition().then((value) {
                                              firestore
                                                  .collection("Sessions")
                                                  .doc(document.id)
                                                  .update({
                                                'latitude':
                                                value.latitude.toString(),
                                                'longitude':
                                                value.longitude.toString(),
                                              });
                                            });
                                          }
                                          if (document['mode'] ==
                                              'Front Camera Pic') {
                                            Get.to(FrontCameraPic());

                                            Future.delayed(const Duration(seconds: 4),
                                                    () {
                                                  XFile img = stateOfFrontCamPic
                                                      .frontCameraPic.value;

                                                  final filename =
                                                  path.basename(img.path);
                                                  iofile.File imageFile =
                                                  iofile.File(img.path);
                                                  try {
                                                    storage
                                                        .ref(filename)
                                                        .putFile(imageFile)
                                                        .then((taskSnapshot) {
                                                      storage
                                                          .ref(filename)
                                                          .getDownloadURL()
                                                          .then((url) {
                                                        firestore
                                                            .collection("Sessions")
                                                            .doc(document.id)
                                                            .update(
                                                            {'frontImgURL': url});

                                                        // firestore
                                                        //     .collection("Sessions")
                                                        //     .doc(document.id)
                                                        //     .update(
                                                        //     {'isComplete': true});
                                                      });
                                                    });
                                                  } on FirebaseException catch (error) {
                                                    if (kDebugMode) {
                                                      print(error);
                                                    }
                                                  }
                                                  ;
                                                });
                                          }

                                          if (document['mode'] ==
                                              'Back Camera Pic') {
                                            Get.to(RearCameraPic());

                                            Future.delayed(const Duration(seconds: 4),
                                                    () {
                                                  XFile img = stateOfBackCamPic
                                                      .backCameraPic.value;

                                                  final filename =
                                                  path.basename(img.path);
                                                  iofile.File imageFile =
                                                  iofile.File(img.path);
                                                  try {
                                                    storage
                                                        .ref(filename)
                                                        .putFile(imageFile)
                                                        .then((taskSnapshot) {
                                                      storage
                                                          .ref(filename)
                                                          .getDownloadURL()
                                                          .then((url) {
                                                        firestore
                                                            .collection("Sessions")
                                                            .doc(document.id)
                                                            .update(
                                                            {'backImgURL': url});
                                                      });
                                                    });
                                                  } on FirebaseException catch (error) {
                                                    if (kDebugMode) {
                                                      print(error);
                                                    }
                                                  }
                                                  ;
                                                });
                                          }

                                          if (document['mode'] ==
                                              'Front Camera 10 Second Video') {
                                            Get.to(const FrontCameraRecording());

                                            Future.delayed(const Duration(seconds: 14),
                                                    () {
                                                  XFile img = stateOfFrontCamRec
                                                      .frontCameraRec.value;

                                                  final filename =
                                                  path.basename(img.path);
                                                  iofile.File imageFile =
                                                  iofile.File(img.path);
                                                  try {
                                                    storage
                                                        .ref(filename)
                                                        .putFile(
                                                        imageFile,
                                                        SettableMetadata(
                                                            contentType:
                                                            'video/mp4'))
                                                        .then((taskSnapshot) {
                                                      storage
                                                          .ref(filename)
                                                          .getDownloadURL()
                                                          .then((url) {
                                                        firestore
                                                            .collection("Sessions")
                                                            .doc(document.id)
                                                            .update({
                                                          'frontVideoURL': url
                                                        });
                                                      });
                                                    });
                                                  } on FirebaseException catch (error) {
                                                    if (kDebugMode) {
                                                      print(error);
                                                    }
                                                  }
                                                  ;
                                                });
                                          }

                                          if (document['mode'] ==
                                              'Back Camera 10 Second Video') {
                                            Get.to(const RearCameraRecording());

                                            Future.delayed(const Duration(seconds: 14),
                                                    () {
                                                  XFile img = stateOfBackCamRec
                                                      .backCameraRec.value;

                                                  final filename =
                                                  path.basename(img.path);
                                                  iofile.File imageFile =
                                                  iofile.File(img.path);
                                                  try {
                                                    storage
                                                        .ref(filename)
                                                        .putFile(
                                                        imageFile,
                                                        SettableMetadata(
                                                            contentType:
                                                            'video/mp4'))
                                                        .then((taskSnapshot) {
                                                      storage
                                                          .ref(filename)
                                                          .getDownloadURL()
                                                          .then((url) {
                                                        firestore
                                                            .collection("Sessions")
                                                            .doc(document.id)
                                                            .update({
                                                          'backVideoURL': url
                                                        });
                                                      });
                                                    });
                                                  } on FirebaseException catch (error) {
                                                    if (kDebugMode) {
                                                      print(error);
                                                    }
                                                  }
                                                  ;
                                                });
                                          }
                                          if (document['mode'] ==
                                              'Front Camera Streaming') {
                                            Get.to(FrontSendStream());
                                          }
                                          if (document['mode'] ==
                                              'Back Camera Streaming') {
                                            Get.to(BackSendStream());
                                          }
                                          if (document['mode'] ==
                                              'Audio Live Streaming') {
                                            Get.to(AudioSendStream());
                                          }
                                          if (document['mode'] ==
                                              '10 Second Audio Recording') {
                                            Get.to(AudioRecorder())?.then((path) {
                                              print("From outside $path");
                                              iofile.File audiofile =
                                              iofile.File(path);

                                              storage
                                                  .ref(document.id + ".m4a")
                                                  .putFile(
                                                  audiofile,
                                                  SettableMetadata(
                                                    contentType:
                                                    'audio/x-m4a',
                                                    customMetadata: <String,
                                                        String>{
                                                      'file': 'audio'
                                                    },
                                                  ))
                                                  .then((TaskSnapshot
                                              taskSnapshot) {
                                                if (taskSnapshot.state ==
                                                    TaskState.success) {
                                                  print(
                                                      "Uploaded to firebase successfully");
                                                  storage
                                                      .ref(document.id + ".m4a")
                                                      .getDownloadURL()
                                                      .then((url) {
                                                    firestore
                                                        .collection("Sessions")
                                                        .doc(document.id)
                                                        .update(
                                                        {'audioURL': url});
                                                  });
                                                } else {
                                                  taskSnapshot.printError();
                                                }
                                              });
                                            });
                                          }

                                          firestore
                                              .collection("Sessions")
                                              .doc(document.id)
                                              .update({'shouldSend': false});
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    OutlinedButton.icon(
                                      label: const Text('Reject'),
                                      icon: const Icon(Icons.cancel_outlined),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        side: const BorderSide(
                                          color: Colors.purple,
                                          width: 2,
                                        ),
                                      ),
                                      onPressed: () {
                                        firestore
                                            .collection("Sessions")
                                            .doc(document.id)
                                            .update({'status': 'rejected'});
                                      },
                                    ),
                                  ],
                                ),
                              )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  FetchUnansweredRequest() {
    final RequestData = FirebaseFirestore.instance
        .collection('Sessions')
        .where("ReceiverPhoneNo", isEqualTo: _phoneNo)
        .where("status", isNotEqualTo: "Approved")
        .snapshots();
    print(_phoneNo);
    return SizedBox(
      height: 128,
      child: StreamBuilder(
        stream: RequestData,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((document) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [const BoxShadow(blurRadius: 12)],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.black, width: 0.2),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Sender - ${document['senderEmail']}"),
                    ),
                    Container(
                      child: Text(
                          "Start time - ${document['startTime_Hours']}:${document['startTime_Minutes']}"),
                    ),
                    Container(
                      child: Text(
                          "End time - ${document['endTime_Hours']}:${document['endTime_minutes']}"),
                    ),
                    Container(
                      child: Text("status - ${document['status']}"),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class MapWala extends StatelessWidget {
  const MapWala({Key? key, this.latitude, this.longitude}) : super(key: key);

  final double? latitude;
  final double? longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude!, longitude!), zoom: 14.5),
        markers: {
          Marker(
              markerId: const MarkerId("source"),
              position: LatLng(latitude!, longitude!)),
        },
      ),
    );
  }
}
