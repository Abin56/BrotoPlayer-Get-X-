import 'dart:io';
import 'package:broto_player/Database/datamode.dart';
import 'package:broto_player/Getx/player_getx.dart';
import 'package:broto_player/Pages/Recent/R_video_list.dart';
import 'package:broto_player/videoplayer/widget/Project/controls.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'data_manager.dart';

class AllvideoPlayer extends StatelessWidget {
  final playercontroller = Get.put(AllPlayerContoller());
  
  AllvideoPlayer({Key? key,  
  // this.index = 0, required this.urls
  })
      : super(key: key);


  // _AllvideoPlayerState createState() => _AllvideoPlayerState();
// }

// class _AllvideoPlayerState extends State<AllvideoPlayer> {
  late FlickManager flickManager;
  late DataManager dataManager;
 

 
    // Recentlistingmode obj = Recentlistingmode(recentpath: playercontroller. urls[playercontroller. index]);
    // getRecentStatus(path: playercontroller. urls[playercontroller. index]);
    
    

  //   super.initState();
  //   flickManager = FlickManager(
  //       videoPlayerController: VideoPlayerController.file(File(
  //         widget.urls[widget.index],
  //       ),
  //       ),
  //       onVideoEnd: () {
  //         dataManager.skipToNextVideo(Duration(seconds: 5));
  //       });

  //   dataManager = DataManager(flickManager: flickManager, urls: widget.urls);
  // }

  // @override
  // void dispose() {
  //   flickManager.dispose();
  //   super.dispose();
  // }

  skipToVideo(String url) {
    flickManager.handleChangeVideo(VideoPlayerController.file(File(url[playercontroller.index])));
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: Column(
        children: [
        
          Container(
            height: MediaQuery.of(context).size.height,
            child: FlickVideoPlayer(
              flickManager: flickManager,
              preferredDeviceOrientationFullscreen: [
                // DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft,
                // DeviceOrientation.landscapeRight,
              ],
              flickVideoWithControls: FlickVideoWithControls(
                controls: CustomOrientationControls(dataManager: dataManager),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                videoFit: BoxFit.cover,
                controls: CustomOrientationControls(dataManager: dataManager),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


