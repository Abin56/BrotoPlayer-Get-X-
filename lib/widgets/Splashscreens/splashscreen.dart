import 'package:broto_player/Database/datamode.dart';
import 'package:broto_player/Getx/getx.dart';
import 'package:broto_player/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import '../../Fetching files/InnerFetching/fetch_video_data.dart';

import '../../homescreen.dart';
import 'onboarding.dart';
final result = getHiveThumbnail();


class Splashscreen extends StatelessWidget {
  final homecontroller = Get.put(StateGetx());
// final examplecontoler = Get.find<StateGetx>()
  Splashscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  

    GoHomeScreen(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset("asset/images/splashscreen logo.jpg"),
      ),
    );
  }

  // ignore: non_constant_identifier_names

}

GoHomeScreen(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isOnBoard = prefs.getBool('seenonboard');
  if (isOnBoard == true) {
    await Future.delayed(const Duration(seconds: 10));
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => Homescreen()));
  } else {
    await Future.delayed(const Duration(seconds: 10));
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => Onboardingpage()));
  }
}
Future<String> getHiveThumbnail({String ? tumbnail}) async {
  final fileName = await VideoThumbnail.thumbnailFile(
    video: tumbnail!,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.PNG,
    quality: 100,
  );
  final addimagetohive = ImageStoreDB(imagestore: fileName.toString());
  final objimage = await imageDB.add(addimagetohive);
 final  getimage = imageDB.get(objimage);



  return fileName!;
}
