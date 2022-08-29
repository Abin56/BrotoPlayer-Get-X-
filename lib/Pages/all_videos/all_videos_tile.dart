import 'dart:developer';
import 'dart:io';

import 'package:broto_player/Fetching%20files/InnerFetching/load_folder_video.dart';
import 'package:broto_player/Getx/getx.dart';
import 'package:broto_player/widgets/Splashscreens/splashscreen.dart';
import 'package:broto_player/widgets/loding/circularind_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../Database/datamode.dart';
import '../../Fetching files/InnerFetching/fetch_video_data.dart';
import '../../main.dart';
import '../../videoplayer/thumbnail.dart';
import '../../videoplayer/widget/Project/allvideoplayer.dart';
import '../../widgets/Drawer/drawer.dart';
import '../Add favou/video_tile_popup.dart';
import 'package:path_provider/path_provider.dart';

final ScrollController _scrollController = ScrollController();

class AllVideoTile extends StatelessWidget {
  final homecontroller = Get.put(StateGetx());
  AllVideoTile({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: AnimationLimiter(
        child: ValueListenableBuilder(
            valueListenable: videoDB.listenable(),
            builder: (ctx, Box<DbVideplayer> videoList, Widget? child) {
              return videoList.isEmpty
                  ? emptyDisplay("Videos")
                  : ListView.builder(
                      cacheExtent: 9999,

                      controller: _scrollController,
                      padding: EdgeInsets.all(_w / 30),
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: videoList.values.length,
                      //////
                      //video Length.................
                      ///
                      itemBuilder: (BuildContext context, int index) {
                        DbVideplayer? video = videoDB.getAt(index);

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: const Duration(milliseconds: 100),
                          child: SlideAnimation(
                            duration: const Duration(milliseconds: 2500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: FadeInAnimation(
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(milliseconds: 2500),
                              child: Container(
                                margin: EdgeInsets.only(bottom: _w / 15),
                                height: _w / 4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllvideoPlayer( 
                                                        urls: fetchedVideosPath,
                                                        index: index,
                                                      ))),
                                          title: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  height: 200,
                                                  child: Text(
                                                    video!.videoName.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          leading: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: SizedBox(
                                              height: 200,
                                              width: 90,
                                              child: Center(
                                                child: FutureBuilder(
                                                  future: getHiveThumbnail(
                                                      video, index),
                                                  builder: (context,
                                                          AsyncSnapshot<String?>
                                                              snapshot) =>
                                                      snapshot.hasData
                                                          ? Image.file(File(
                                                              video.thumbnail))
                                                          : Center(
                                                              child: Lottie.asset('asset/images/loading lottiefile.json')
                                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          trailing: getPopup(
                                              path: video.videoPath,
                                              context: context)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }),
      ),
    );
  }
}

Future<String> getHiveThumbnail(DbVideplayer video, int index) async {
  if (video.thumbnail.isNotEmpty) {
    return '';
  } else {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: video.videoPath.toString(),
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 100,
    );
    video.thumbnail = fileName.toString();
    videoDB.putAt(index, video);
    return fileName!;
  }
}
