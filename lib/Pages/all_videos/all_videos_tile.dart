import 'dart:developer';
import 'dart:io';

import 'package:broto_player/Fetching%20files/InnerFetching/load_folder_video.dart';
import 'package:broto_player/Getx/player_getx.dart';
import 'package:broto_player/widgets/loding/circularind_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../Database/datamode.dart';
import '../../Fetching files/InnerFetching/fetch_video_data.dart';
import '../../main.dart';
import '../../videoplayer/thumbnail.dart';
import '../../videoplayer/widget/Project/allvideoplayer.dart';
import '../../widgets/Drawer/drawer.dart';
import '../Add favou/video_tile_popup.dart';

bool boolimage = false;
bool isLoadingData = false;
bool hasMoreData = true;
final ScrollController _scrollController = ScrollController();

class AllVideoTile extends StatelessWidget {
  final allvideocontroller = Get.find<AllPlayerContoller>();
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
              // return videoList.isEmpty
              //     ? emptyDisplay("Videos")
              //     //else
              //     :
              if (videoList.isEmpty) {
                hasMoreData = false;
              }
              return ListView.builder(
                cacheExtent: 9999,

                controller: _scrollController,
                padding: EdgeInsets.all(_w / 30),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: hasMoreData
                    ? videoList.values.length
                    : videoList.values.length + 1, ///////
                //video Length.................
                ///
                itemBuilder: (BuildContext context, int index) {
                  DbVideplayer? video = videoDB.getAt(index);
                  if (index < videoList.values.length) {
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
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
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) {
                                                allvideocontroller.urls = fetchedVideosPath;
                                                allvideocontroller.index = index;
                                                return   AllvideoPlayer(
                                                    // urls: fetchedVideosPath,
                                                    // index: index,
                                                  );
                                              }
                                                
                                                  )),
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
                                                overflow: TextOverflow.ellipsis,
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
                                        padding: const EdgeInsets.only(top: 5),
                                        child: SizedBox(
                                            height: 200,
                                            width: 90,
                                            child: Center(
                                              child: FutureBuilder(
                                                future: getThumbnail(
                                                    video.videoPath.toString()),
                                                builder: (context,
                                                        AsyncSnapshot<String?>
                                                            snapshot) =>
                                                    snapshot.hasData
                                                        ? Image.file(File(
                                                            snapshot.data!))
                                                        : Center(
                                                          child: Loading(),
                                                          ),
                                              ),
                                            )),
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
                  } else {
                    return const ListTile(
                      title: Text(
                        "No more Videos ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
              );
            }),
      ),
    );
  }
}

getList() {
  List<ImageStoreDB> objList = imageDB.values.toList();
  List<String> imagepath = [];
  for (ImageStoreDB obj in objList) {
    imagepath.add(obj.imagestore);
  }
}

storeimagepath({required String path}) {
  List<ImageStoreDB> storeimage = imageDB.values.toList();

  List<ImageStoreDB> result =
      storeimage.where((checking) => checking.imagestore == path).toList();
  if (result.isEmpty) {
    var imageobj = ImageStoreDB(imagestore: path);
    imageDB.add(imageobj);
  } else {
    boolimage = true;
  }
}
  // void getData() async {
  //   // Paging View


  //   if (isLoadingData && hasMoreData) {
  //     isLoadingData = true;
  //     List.generate(8,(index)=>videoDB.values.toList());
  //     setState(() {});
  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  // }

  // @override
  // void initState() {
  //   filteredFolderVideos.value.clear();
  //   getData();
  //   _scrollController.addListener(() {
  //     if (_scrollController.offset ==
  //         _scrollController.position.maxScrollExtent) {
  //       getData();
  //     }
  //   });
  //   super.initState();
  // }