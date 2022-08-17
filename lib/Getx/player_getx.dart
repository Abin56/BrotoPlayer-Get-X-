import 'dart:io';

import 'package:broto_player/Database/datamode.dart';
import 'package:broto_player/Pages/Recent/R_video_list.dart';
import 'package:broto_player/videoplayer/widget/Project/data_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
 import 'package:flutter/src/widgets/framework.dart'; 

class AllPlayerContoller extends GetxController {
  late FlickManager flickManager;
  late DataManager dataManager;
  late List<String> urls;
  int index = 0;

  @override
  void onReady() {
    Recentlistingmode obj = Recentlistingmode(recentpath: urls[index]);
    getRecentStatus(path: urls[index]);
    //
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(
          File(
            urls[index],
          ),
        ),
        onVideoEnd: () {
          dataManager.skipToNextVideo(Duration(seconds: 5));
        });

    dataManager = DataManager(flickManager: flickManager, urls: urls);
    super.onReady();
  }

  skipToVideo(String url) {
    flickManager
        .handleChangeVideo(VideoPlayerController.file(File(url[index])));
  }
}
