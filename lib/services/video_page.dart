import 'dart:io';
import 'package:components/utils/tabBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget{

  VideoPage({required this.videoLink, required this.videoMode});

  final String videoLink;

  final String videoMode;

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  
  late VideoPlayerController controller;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer(){
     controller = VideoPlayerController.network(widget.videoLink);
     controller.addListener(() {
        setState(() {});
     });
    controller.initialize().then((value){
        setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar( 
              title: Text("${widget.videoMode} Camera video"),
              backgroundColor: Colors.purple,
          ),
          body: Container( 
            child: Column(
              children:[
                  Expanded(
                    child: AspectRatio( 
                      aspectRatio: controller.value.aspectRatio,
                       child: VideoPlayer(controller),
                    ),
                  ),

                  Container( //duration of video
                     child: Text("Total Duration: " + controller.value.duration.toString()),
                  ),

                  Container(
                      child: VideoProgressIndicator(
                        controller, 
                        allowScrubbing: true,
                        colors:VideoProgressColors(
                            backgroundColor: Colors.redAccent,
                            playedColor: Colors.green,
                            bufferedColor: Colors.purple,
                        )
                      )
                  ),

                  Container(
                     child: Row(
                         children: [
                            IconButton(
                                onPressed: (){
                                  if(controller.value.isPlaying){
                                    controller.pause();
                                  }else{
                                    controller.play();
                                  }

                                  setState(() {
                                    
                                  });
                                }, 
                                icon:Icon(controller.value.isPlaying?Icons.pause:Icons.play_arrow)
                           ),

                           IconButton(
                                onPressed: (){
                                  controller.seekTo(Duration(seconds: 0));

                                  setState(() {
                                    
                                  });
                                }, 
                                icon:Icon(Icons.stop)
                           )
                         ],
                     ),
                  )
              ]
            )
          ),
       );
  }
}