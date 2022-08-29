import 'dart:io';

import 'package:broto_player/Database/datamode.dart';
import 'package:broto_player/Pages/all_videos/all_videos_tile.dart';
import 'package:broto_player/main.dart';
import 'package:broto_player/videoplayer/thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:lottie/lottie.dart';
import '../../Fetching files/InnerFetching/video_with_info.dart';
import '../../videoplayer/widget/Project/allvideoplayer.dart';

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: ((context) => const Homescreen())));
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final mylist = query.isEmpty
        ? fetchedVideosWithInfo.value
        : fetchedVideosWithInfo.value
            .where((checking) =>
                checking.title!.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return Scaffold(
        backgroundColor: Colors.black,
        body: mylist.isEmpty
            ? const Text("No matching found")
            : ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: mylist.length,
                itemBuilder: (context, index) {
                  // log(mylist.length.toString());
                  List<String> calling = getlist(mylist, index);
                  final VideoData video = mylist[index];
                  DbVideplayer? videos = videoDB.getAt(index);
                  return ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            AllvideoPlayer(urls: calling, index: index),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50,
                      child: FutureBuilder(
                        future: getHiveThumbnail(videos!, index),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Image.file(File(videos.thumbnail));
                          } else {
                            return Center(
                              child: LottieBuilder.asset(
                                  'asset/images/loading lottiefile.json'),
                            );
                          }
                        },
                      ),
                    ),
                    title: Text(
                      video.title!,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ));
  }

  getlist(List<VideoData> mylist, index) {
    List<String> videopath = [];
    for (VideoData obj in mylist) {
      videopath.add(obj.path!);
    }
    return videopath;
  }
}
