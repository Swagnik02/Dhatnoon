// BackSendStream, BackRecieveStream
/*
Future.delayed(Duration(seconds: 2), () {
      switchCameraNew(sessionController: _client.sessionController);
    });
 */

import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:camera/camera.dart';
import 'package:components/utils/tabBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class BackSendStream extends StatelessWidget {

  String token = "twat";

  getCode() async {
    String link =
        "https://agora-node-tokenserver.davidcaleb.repl.co/access_token?channelName=test";
    Response response = await get(Uri.parse(link));
    Map data = jsonDecode(response.body);
    token = data["token"];
  }

  @override
  Widget build(BuildContext context) {
    return BackSendStreamIntermediate(token: token);
  }
}

class BackSendStreamIntermediate extends StatefulWidget {
  const BackSendStreamIntermediate({
    Key? key,
    required this.token
  }) : super(key: key);

  final String token;

  @override
  State<BackSendStreamIntermediate> createState() => _BackSendStreamIntermediateState();
}

class _BackSendStreamIntermediateState extends State<BackSendStreamIntermediate> {
  late final AgoraClient _client;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    startEverything();
    setClient();
    initAgora();
  }

  startEverything() async {
    final cameras = await availableCameras();
    final frontCamera = cameras[1];


    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;
  }

  void setClient() async {
    _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: "63a29f76b5704dd0bf01316fc9f8f736",
          channelName: "test",
          tempToken: widget.token
        // username: "user",
      ),
    );
  }

  void initAgora() async {
    await _client.initialize();
  }

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {

      Future.delayed(Duration(seconds: 2), () {
        switchCamera(sessionController: _client.sessionController);
      });

    return MaterialApp(
      home: Stack(
        children: [
          MyHomePage(),
          Visibility(
            visible: false,
            maintainState: true,
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Front camera streaming',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
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
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    AgoraVideoViewer(
                      client: _client,
                      layoutType: Layout.floating,
                      enableHostControls:
                      true, // Add this to enable host controls
                    ),
                    AgoraVideoButtons(
                      client: _client,
                      autoHideButtons: false,
                      enabledButtons: [BuiltInButtons.callEnd],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackRecieverStream extends StatelessWidget {

  String token = "twat";

  getCode() async {
    String link =
        "https://agora-node-tokenserver.davidcaleb.repl.co/access_token?channelName=test";
    Response response = await get(Uri.parse(link));
    Map data = jsonDecode(response.body);
    token = data["token"];
  }

  @override
  Widget build(BuildContext context) {
    return BackReciverStreamIntermediate(token: token);
  }
}

class BackReciverStreamIntermediate extends StatefulWidget {
  const BackReciverStreamIntermediate({
    Key? key,
    required this.token
  }) : super(key: key);

  final String token;

  @override
  State<BackReciverStreamIntermediate> createState() => _BackReciverStreamIntermediateState();
}

class _BackReciverStreamIntermediateState extends State<BackReciverStreamIntermediate> {

  late final AgoraClient _client;

  @override
  void initState() {
    super.initState();
    setClient();
    initAgora();
  }

  void setClient() async {
    _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: "63a29f76b5704dd0bf01316fc9f8f736",
          channelName: "test",
          tempToken: widget.token
        // username: "user",
      ),
    );
  }

  void initAgora() async {
    await _client.initialize();
  }

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Stack(
        children: [
          Visibility(
            visible: true,
            maintainState: true,
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Front camera streaming',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
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
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    AgoraVideoViewer(
                      client: _client,
                      layoutType: Layout.floating,
                      enableHostControls: false,
                      floatingLayoutContainerHeight: height - 88,
                      floatingLayoutContainerWidth: width, // Add this to enable host controls
                    ),
                    AgoraVideoButtons(
                      client: _client,
                      autoHideButtons: false,
                      enabledButtons: [BuiltInButtons.callEnd],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}