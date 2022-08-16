import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../../Database/datamode.dart';
import '../../main.dart';
import '../../widgets/Drawer/drawer.dart';
import '../Add playlist/addplaylist.dart';
import '../PlayList/Playlist.dart';
import 'favourites.dart';

Widget getPopup({required path, required context}) {
  return PopupMenuButton(
    onSelected: (value) {
      if (value == 'Fav') {
        getfavStatus(path: path);
        getsnackbar(context: context);
      }
      if (value == 'Play') {
        return getPLopupaddvideos(context: context, path: path);
      }
    },
    icon: const Icon(
      Icons.more_vert,
      color: Colors.orange,
    ),
    color: Colors.black,
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 'Fav',
          child: Row(
            children: const [
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              Text(
                "Add to favourites",
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
      PopupMenuItem(
          value: 'Play',
          child: Row(
            children: const [
              Icon(
                Icons.add,
                color: Colors.green,
              ),
              Text(
                "Add to Playlist",
                style: TextStyle(color: Colors.green),
              )
            ],
          ))
    ],
  );
}

getPLopupaddvideos({required context, required path}) {
  bool isadded = false;
  GlobalKey<FormState> formkey = GlobalKey();
  final controller = TextEditingController();
  return showDialog(
      context: context,
      builder: (ctx1) {
        return AlertDialog(
          title: const Text("Add videos to Playlist"),
          content: SizedBox(
            height: 300,
            child: Column(
              children: [
                Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Invalid the Folder name is empty!";
                        } else if (getplaylistsatus(playlistpath: value)) {
                          return "Already exist";
                        }
                        return null;
                      }),
                ),
                TextButton.icon(
                    onPressed: () {
                      bool isadded = false;
                      if (formkey.currentState!.validate()) {
                        PlaylistModel objplaylist =
                            PlaylistModel(addplaylist: controller.text);
                        playistDB.add(objplaylist);
                        
                   showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("PlayList"),
                  content: const Text("Folder added",style: TextStyle(color: Colors.green),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(14),
                        child: const Text("ok"),
                      ),
                    ),
                  ],
                ),
                   );
                        formkey.currentState!.reset();
                        
                      }
                      controller.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add")),
                Expanded(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: ValueListenableBuilder(
                      valueListenable: playistDB.listenable(),
                      builder: (BuildContext context,
                              Box<PlaylistModel> listenplaylist,
                              Widget? child) =>
                          playistDB.isEmpty
                              ? emptyDisplay("Videos")
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: playistDB.values.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    PlaylistModel? playlistobj =
                                        playistDB.getAt(index);
                                    return PopPlaylistFolder(
                                      folderName: playlistobj!,
                                      index: index,
                                      videoPath: path,
                                    );
                                  },
                                ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}


