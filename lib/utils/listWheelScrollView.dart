import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../state_management/list_item.dart';

class ListWheel extends StatefulWidget {
  ListWheel({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ListWheelState createState() => _ListWheelState();
}

class _ListWheelState extends State<ListWheel> {
  ListItem listItem = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select your choice"),
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
          centerTitle: true,
        ),
        backgroundColor: Color(0xffcfd8dc),
        body: ListView.builder(
          itemCount: 9,
          itemBuilder: (context, index) {
            return _child(index);
          },

        ));
  }

  Widget _child(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Card(
        shadowColor: Color.fromARGB(255, 90, 26, 150),
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(colors: [
              Color(0xff270745),
              Color(0xff250543),
              Color(0xff170036),
              Color(0xff120032),
              Color(0xff120032),
            ]),
          ),
          child: Center(
            child: ListTile(
              title: Text(
                _items[index],
                style: TextStyle(color: Colors.white),
              ),
              leading: _icons[index],
              onTap: (){
                listItem.setListItem(_items[index]);
                Get.back();
              },
            ),
          ),
        ),
      ),
    );
  }
}

List<String> _items = [
  "Live Geo Location",
  "Front Camera Pic",
  "Back Camera Pic",
  "Front Camera Streaming",
  "Back Camera Streaming",
  "Front Camera 10 Second Video",
  "Back Camera 10 Second Video",
  "Audio Live Streaming",
  "10 Second Audio Recording"
];

List<Icon> _icons = [
  Icon(Icons.location_on_outlined, color: Colors.white),
  Icon(Icons.camera_front_outlined, color: Colors.white),
  Icon(Icons.camera_rear_outlined, color: Colors.white),
  Icon(Icons.photo_camera_front_outlined, color: Colors.white),
  Icon(Icons.photo_camera_back_outlined, color: Colors.white),
  Icon(Icons.video_camera_front_outlined, color: Colors.white),
  Icon(Icons.video_camera_back_outlined, color: Colors.white),
  Icon(Icons.audio_file_sharp, color: Colors.white),
  Icon(Icons.record_voice_over_outlined, color: Colors.white),
];
