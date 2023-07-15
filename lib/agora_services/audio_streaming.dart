/*
AudioSendStream, AudioRecieveStream

Future.delayed(Duration(seconds: 2), () {
      toggleCameraNew(sessionController: _client.sessionController);
    });

Future<void> toggleCameraNew(
      {required SessionController sessionController}) async {
    var status = await Permission.camera.status;
    if (sessionController.value.isLocalVideoDisabled && status.isDenied) {
      await Permission.camera.request();
    }
    sessionController.value = sessionController.value.copyWith(
        isLocalVideoDisabled: !(sessionController.value.isLocalVideoDisabled));
    await sessionController.value.engine
        ?.muteLocalVideoStream(sessionController.value.isLocalVideoDisabled);
  }
 */

import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:components/utils/tabBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AudioSendStream extends StatelessWidget {

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
    return AudioSendStreamIntermediate(token: token);
  }
}

class AudioSendStreamIntermediate extends StatefulWidget {
  const AudioSendStreamIntermediate({
    Key? key,
    required this.token
  }) : super(key: key);

  final String token;

  @override
  State<AudioSendStreamIntermediate> createState() => _AudioSendStreamIntermediateState();
}

class _AudioSendStreamIntermediateState extends State<AudioSendStreamIntermediate> {
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
    Future.delayed(Duration(seconds: 2), () {
      toggleCamera(sessionController: _client.sessionController);
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

class AudioRecieverStream extends StatelessWidget {

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
    return AudioReciverStreamIntermediate(token: token);
  }
}

class AudioReciverStreamIntermediate extends StatefulWidget {
  const AudioReciverStreamIntermediate({
    Key? key,
    required this.token
  }) : super(key: key);

  final String token;

  @override
  State<AudioReciverStreamIntermediate> createState() => _AudioReciverStreamIntermediateState();
}

class _AudioReciverStreamIntermediateState extends State<AudioReciverStreamIntermediate> {

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